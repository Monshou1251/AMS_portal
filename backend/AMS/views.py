from django.conf import settings
from django.core.cache import cache
from datetime import datetime, timedelta
from .models import *
from rest_framework import viewsets
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from django.conf import settings

from sqlalchemy import create_engine
import pyexasol

from sqlalchemy import (
    create_engine,
    MetaData,
    delete,
    select,
    func,
    update,
    Table,
    inspect,
    and_,
    or_,
)
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.exc import IntegrityError
from sqlalchemy.engine.reflection import Inspector

from .config_reader import read_config_file
import logging
import json


logger = logging.getLogger(__name__)

EXASOL_DB_NAME = settings.EXASOL_DB_NAME
EXASOL_DB_NAME_DIRECT = settings.EXASOL_DB_NAME_DIRECT


@api_view(["POST"])
@permission_classes([])
def set_exasol_credentials(request):
    raw_username = request.data.get("username")
    username = raw_username.split("@")[0]
    password = request.data.get("password")

    if username and password:
        exasol_connection_key = f"exasol_connection_{username}"
        exasol_connection_string = (
            f"exa+pyodbc://{username}:{password}@{EXASOL_DB_NAME}"
        )
        cache.set(exasol_connection_key, exasol_connection_string, timeout=None)
        test_cahce_name = cache.get(exasol_connection_key)

        pyexasol_connection_key = f"pyexasol_connection_{username}"
        pyexasol_connection_string = {
            "dsn": f"{EXASOL_DB_NAME_DIRECT}",
            "user": f"{username}",
            "password": f"{password}",
        }
        cache.set(pyexasol_connection_key, pyexasol_connection_string, timeout=None)

        response = {"message": "Exasol credentials set successfully."}
    else:
        reponse = {"error": "Invalid credentials provided."}

    return Response(response)


@api_view(["GET"])
@permission_classes([IsAuthenticated])
def exasol_data_view(request):
    current_time = datetime.now()
    logger.info(f'{request.method} request received. Data: {request.GET.get("table")}')
    # logger.info('Test LOG')
    page = int(request.GET.get("page", 1))
    page_size = int(request.GET.get("page_size", 20))
    table_full_name = request.GET.get("table")
    filter_params = request.GET.get("filters", "[]")
    sort_by = request.GET.get("sort_by")
    sort_order = request.GET.get("sort_order")

    schema_name, table_name = table_full_name.split(".")

    username = request.headers.get("X-Username", None)
    exasol_connection_key = f"exasol_connection_{username}"
    exasol_connection_string = cache.get(exasol_connection_key)
    engine = create_engine(exasol_connection_string)

    Session = sessionmaker(bind=engine)
    session = Session()

    metadata = MetaData(bind=engine)
    table = Table(f"{table_name}", metadata, autoload=True, schema=schema_name)

    # Parse filter data
    try:
        filter_data = json.loads(filter_params)

    except json.JSONDecodeError:
        return Response({"error": "Invalid filter format"})

    # Parsing filter condition
    filter_conditions = []
    for column_name, filters in filter_data.items():
        if column_name in table.columns:
            for filter_info in filters:
                filter_type = filter_info["type"]
                filter_value = filter_info["value"]

                if filter_type == "equals":
                    condition = getattr(table.c, column_name) == filter_value
                elif filter_type == "contains":
                    condition = getattr(table.c, column_name).contains(filter_value)

                filter_conditions.append(condition)

    # Parsing sorting condition
    sort_condition = None
    if sort_by and sort_order:
        if hasattr(table.c, sort_by):
            if sort_order == "asc":
                sort_condition = getattr(table.c, sort_by).asc()
            elif sort_order == "desc":
                sort_condition = getattr(table.c, sort_by).desc()
    else:
        primary_key_column = table.primary_key.columns.keys()[0]
        sort_condition = getattr(table.c, primary_key_column).asc()

    primary_keys = [column.name for column in table.primary_key]
    primary_key_column = primary_keys[0]

    offset_value = (page - 1) * page_size

    columns = table.columns.keys()

    if primary_key_column not in columns:
        return Response(
            {"error": f"Primary key {primary_key_column} not found in columns."}
        )

    with engine.connect() as conn:
        # Calculate the total count considering filters
        total_count_query = select([func.count()]).select_from(table)
        if filter_conditions:
            total_count_query = total_count_query.where(and_(*filter_conditions))
        total_count = conn.execute(total_count_query).scalar()

        # Adjust the offset to be within the total count range
        offset_value = min((page - 1) * page_size, total_count)

        # Create the base query for fetching data
        base_query = select([table])
        if filter_conditions:
            base_query = base_query.where(and_(*filter_conditions))

        # Apply sorting condition if specified
        if sort_condition is not None:
            base_query = base_query.order_by(sort_condition)

        primary_key_column_object = getattr(table.c, primary_key_column)

        # Create the final query with limit and offset
        final_query = base_query.limit(page_size).offset(offset_value)

        # Execute the final query to get the paginated and filtered data
        result = conn.execute(final_query)
        data = result.fetchall()

        # Calculate the primary key range for the current page
        range_query = (
            select([primary_key_column_object])
            .order_by(primary_key_column_object)
            .limit(page_size)
            .offset(offset_value)
        )
        range_result = conn.execute(range_query)
        primary_key_range = [row[0] for row in range_result.fetchall()]

        # Update the condition to use the primary key range and filter conditions
        condition = primary_key_column_object.in_(primary_key_range)
        if filter_conditions:
            condition = and_(condition, *filter_conditions)

        # Create the query for counting total rows after filtering
        # total_count_query = select([func.count()]).select_from(table).where(condition)
        # total_count = conn.execute(total_count_query).scalar()

        # Check if the filtered data on the current page are less than the specified page size
        if len(data) < page_size and page > 1:
            # If so, set the offset back to the default one for the first page
            remaining_rows = total_count % page_size
            offset_value = max(0, total_count - remaining_rows)
            final_query = base_query.limit(page_size).offset(offset_value)
            result = conn.execute(final_query)
            data = result.fetchall()

    formatted_data = []
    for row in data:
        formatted_row = dict(zip(columns, row))
        formatted_data.append(formatted_row)

    # Get the number of total rows for pagination
    filter_conditions_for_count = []
    for condition in filter_conditions:
        filter_conditions_for_count.append(condition)

    total_count_query = session.query(func.count()).select_from(table)
    if filter_conditions_for_count:
        total_count_query = total_count_query.filter(*filter_conditions_for_count)

    total_count = total_count_query.scalar()
    response = {
        "data": formatted_data,
        "total_count": total_count,
        "columns": columns,
        "column_types": {column.name: str(column.type) for column in table.columns},
        "config_data": read_config_file(),
        "primary_keys": primary_keys,
    }

    return Response(response)


@api_view(["GET"])
# @permission_classes([IsAuthenticated])
def user_access_view(request):
    """
    This function retrieves user access data from the database and returns it in the API response.
    The response will contain 2 foreign keys values, user_id will be replaced
    with actual username instead of user_id, and sheet_id will be replaced
    with actual sheet name.

    Args:
       request: The HTTP request object.

    Returns:
        Response: The API response containing user access data.
    """
    page = int(request.GET.get("page", 1))
    page_size = int(request.GET.get("page_size", 20))

    table_name = "ams_portal.user_access"

    username = request.headers.get("X-Username", None)
    exasol_connection_key = f"exasol_connection_{username}"
    exasol_connection_string = cache.get(exasol_connection_key)

    engine = create_engine(exasol_connection_string)
    Session = sessionmaker(bind=engine)
    session = Session()

    metadata = MetaData(bind=engine)
    metadata.reflect(schema="ams_portal")
    data_to_send = read_config_file()
    table = Table(f"user_access", metadata, autoload=True, schema="ams_portal")

    def get_primary_keys(table):
        return [column.name for column in table.primary_key]

    if table_name in metadata.tables:
        table = metadata.tables[table_name]
        users_table = metadata.tables["ams_portal.users"]
        portal_sheets_table = metadata.tables["ams_portal.portal_sheets"]
        primary_keys = get_primary_keys(table)
        print("$$$$$$$$$$$$$$$$$$$$$$$$$$")
        print(primary_keys)

        query = (
            select(
                table.c.id,
                users_table.c.login_name,
                portal_sheets_table.c.sheet_name,
                table.c.allowed,
            )
            .join(users_table, table.c.user_id == users_table.c.id)
            .join(portal_sheets_table, table.c.sheet_id == portal_sheets_table.c.id)
            .order_by(
                users_table.c.login_name,
            )
            .limit(page_size)
            .offset((page - 1) * page_size)
        )

        with engine.connect() as conn:
            result = conn.execute(query)
            data = result.fetchall()

        columns = table.columns.keys()
        formatted_data = []
        for row in data:
            formatted_row = dict(zip(columns, row))
            formatted_data.append(formatted_row)

        primary_keys = table.primary_key.columns.values()[0].name
        print("************")
        print(primary_keys)
        column_types = {column.name: str(column.type) for column in table.columns}
        total_count = session.query(func.count()).select_from(table).scalar()
        response = {
            "data": formatted_data,
            "total_count": total_count,
            "columns": columns,
            "column_types": column_types,
            "primary_keys": primary_keys,
            "config_data": data_to_send,
        }
    else:
        response = {
            "error": f"Table {table_name} does not exist in the database.",
        }

    return Response(response)


@api_view(["PUT"])
# @permission_classes([IsAuthenticated])
def user_access_put_view(request):
    data = request.data
    records = data.get("data", [])
    table_full_name = request.data.get("tableName")
    schema_name, table_name = table_full_name.split(".")

    username = request.headers.get("X-Username", None)
    exasol_connection_key = f"exasol_connection_{username}"
    exasol_connection_string = cache.get(exasol_connection_key)

    engine = create_engine(exasol_connection_string)

    metadata = MetaData(bind=engine)
    metadata.reflect(schema=schema_name)
    table = Table(f"{table_name}", metadata, autoload=True, schema=schema_name)

    users_table = metadata.tables["test_schema.users"]
    portal_sheets_table = metadata.tables["test_schema.portal_sheets"]
    user_access_table = metadata.tables["test_schema.user_access"]

    with engine.connect() as conn:
        for record in records:
            record_id = record.get("id")
            if record_id is not None:
                # Fetch user_id from the record
                user_id = record.get("user_id")
                # Fetch sheet_id from the record
                sheet_id = record.get("sheet_id")

                # Query the ID for the user based on login_name
                user_query = select(users_table.c.id).where(
                    func.lower(users_table.c.login_name) == func.lower(user_id)
                )
                user_id_value = conn.execute(user_query).scalar()

                # Query the ID for the sheet based on sheet_name
                sheet_query = select(portal_sheets_table.c.id).where(
                    func.lower(portal_sheets_table.c.sheet_name) == func.lower(sheet_id)
                )
                sheet_id_value = conn.execute(sheet_query).scalar()

                # Prepare the data for the update
                updated_data = {
                    "id": record_id,
                    "user_id": user_id_value,
                    "sheet_id": sheet_id_value,
                    "allowed": record["allowed"],
                }

                with engine.begin() as trans:
                    update_statement = (
                        update(user_access_table)
                        .values(updated_data)
                        .where(user_access_table.c.id == record_id)
                    )
                    conn.execute(update_statement)
            else:
                pass

    response = {"message": "Data updated successfully."}
    return Response(response)


@api_view(["GET"])
@permission_classes([IsAuthenticated])
def user_permissions_view(request, username):
    """
     This function retrieves user access data from the database and returns it in the API response.

    Args:
       request: The HTTP request object.

    Returns:
        Response: The API response containing user access data.
    """
    page = int(request.GET.get("page", 1))
    page_size = int(request.GET.get("page_size", 20))

    table_name = "user_access"

    username = request.headers.get("X-Username", None)
    exasol_connection_key = f"exasol_connection_{username}"
    exasol_connection_string = cache.get(exasol_connection_key)

    engine = create_engine(exasol_connection_string)
    Session = sessionmaker(bind=engine)
    session = Session()

    metadata = MetaData(bind=engine)
    metadata.reflect()

    if table_name in metadata.tables:
        # Get the table object
        user_permissions_table = metadata.tables[table_name]
        users_table = metadata.tables["users"]
        portal_sheets_table = metadata.tables["portal_sheets"]

        # Create the SQL query to fetch user permissions data for the specified username
        query = (
            select(
                user_permissions_table.c.id,
                users_table.c.login_name,
                portal_sheets_table.c.sheet_name,
                user_permissions_table.c.allowed,
            )
            .join(users_table, user_permissions_table.c.user_id == users_table.c.id)
            .join(
                portal_sheets_table,
                user_permissions_table.c.sheet_id == portal_sheets_table.c.id,
            )
            .where(func.lower(users_table.c.login_name) == func.lower(username))
        )  # Filter by the provided username

        print("printing username:", username)

        # Execute the SQL query and fetch the data
        with engine.connect() as conn:
            result = conn.execute(query)
            data = result.fetchall()
            print("printing data", data)

        # Format the data as a list of dictionaries
        formatted_data = []
        for row in data:
            formatted_row = {
                "id": row[0],
                "username": row[1],
                "sheet_name": row[2],
                "allowed": row[3],
            }
            formatted_data.append(formatted_row)

        # Prepare the API response
        response = {
            "data": formatted_data,
        }
    else:
        # Handle the case when the specified table does not exist in the database
        response = {
            "error": f"Table {table_name} does not exist in the database.",
        }

    return Response(response)


@api_view(["DELETE"])
@permission_classes([IsAuthenticated])
def exasol_data_delete(request):
    data_ids = request.data.get("dataIds", [])
    table_full_name = request.data.get("tableName")
    schema_name, table_name = table_full_name.split(".")

    username = request.headers.get("X-Username", None)
    exasol_connection_key = f"exasol_connection_{username}"
    exasol_connection_string = cache.get(exasol_connection_key)

    try:
        delete_data_from_exasol(
            data_ids, table_name, schema_name, exasol_connection_string
        )
        response = {"message": "Data deleted successfully."}
        print("Printing respone on delete ", response)
    except Exception as e:
        response = {"error": str(e)}
        print("Im in Exception", response)

    return Response(response)


def delete_data_from_exasol(
    data_ids, table_name, schema_name, exasol_connection_string
):
    engine = create_engine(exasol_connection_string)

    metadata = MetaData(bind=engine)
    metadata.reflect(schema=schema_name)

    table = Table(f"{table_name}", metadata, autoload=True, schema=schema_name)

    def get_primary_keys(table):
        return [column.name for column in table.primary_key]

    full_table_name = f"{schema_name}.{table_name}"

    if full_table_name in metadata.tables:
        table = metadata.tables[full_table_name]

        primary_keys = get_primary_keys(table)
        pk = primary_keys[0]

        with engine.connect() as conn:
            for data_id in data_ids:
                delete_statement = delete(table).where(getattr(table.c, pk) == data_id)
                conn.execute(delete_statement)
    else:
        raise ValueError(f"Table {table_name} does not exist in the database.")


@api_view(["PUT"])
@permission_classes([IsAuthenticated])
def exasol_data_update(request):
    updated_data = request.data.get("data")
    table_full_name = request.data.get("tableName")
    schema_name, table_name = table_full_name.split(".")

    username = request.headers.get("X-Username", None)
    exasol_connection_key = f"exasol_connection_{username}"
    exasol_connection_string = cache.get(exasol_connection_key)

    try:
        update_data_in_exasol(
            updated_data, table_name, schema_name, exasol_connection_string
        )
        response = {"message": "Data updated successfully."}
        print("Printing response on update: ", response)
    except IntegrityError as e:
        response = {"error": "Integrity error occurred.", "details": str(e)}
        print("IntegrityError occurred:", response)
    except Exception as e:
        response = {"error": str(e)}
        print("Exception occurred:", response)

    return Response(response)


def update_data_in_exasol(
    updated_data, table_name, schema_name, exasol_connection_string
):
    engine = create_engine(exasol_connection_string)

    metadata = MetaData(bind=engine)
    metadata.reflect(schema=schema_name)
    table = Table(f"{table_name}", metadata, autoload=True, schema=schema_name)

    def get_primary_keys(table):
        return [column.name for column in table.primary_key]

    full_table_name = f"{schema_name}.{table_name}"
    if full_table_name in metadata.tables:
        table = metadata.tables[full_table_name]

        primary_keys = get_primary_keys(table)
        pk = primary_keys[0]

        with engine.begin() as conn:
            for data in updated_data:
                # Extract the primary key value
                primary_key_value = data[pk]

                # Construct the update statement
                update_statement = (
                    update(table)
                    .values(data)
                    .where(getattr(table.c, pk) == primary_key_value)
                )
                conn.execute(update_statement)
    else:
        raise ValueError(f"Table {table_name} does not exist in the database.")


@api_view(["POST"])
@permission_classes([IsAuthenticated])
def exasol_data_create(request):
    new_data = request.data.get("data", [])
    table_full_name = request.data.get("tableName")
    schema_name, table_name = table_full_name.split(".")

    username = request.headers.get("X-Username", None)
    exasol_connection_key = f"exasol_connection_{username}"
    exasol_connection_string = cache.get(exasol_connection_key)

    try:
        create_data_in_exasol(
            new_data, table_name, schema_name, exasol_connection_string
        )
        response = {"message": "Data created successfully."}
        print(("Printing response on create: ", response))
    except Exception as e:
        response = {"error": str(e)}
        print("Error in create operation", response)

    return Response(response)


def create_data_in_exasol(new_data, table_name, schema_name, exasol_connection_string):
    engine = create_engine(exasol_connection_string)

    metadata = MetaData(bind=engine)
    metadata.reflect(schema=schema_name)

    full_table_name = f"{schema_name}.{table_name.lower()}"

    table_names = metadata.tables.keys()
    print("Table names")
    print(table_names)

    if full_table_name in metadata.tables:
        table = metadata.tables[full_table_name]
        print("^^^^^^^^^^^^^^^")
        print(table)

        with engine.connect() as conn:
            for data in new_data:
                # Convert boolean strings to boolean values
                for key, value in data.items():
                    if isinstance(value, str) and value.lower() == "true":
                        data[key] = True
                    elif isinstance(value, str) and value.lower() == "false":
                        data[key] = False

                insert_statement = table.insert().values(data)
                conn.execute(insert_statement)
    else:
        raise ValueError(f"Table {table_name} does not exist in the database.")
