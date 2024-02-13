from rest_framework.exceptions import AuthenticationFailed
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated

from sqlalchemy import create_engine
import pyexasol

from sqlalchemy import create_engine, MetaData, text, Table, inspect
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.exc import IntegrityError
from sqlalchemy.engine.reflection import Inspector

from django.middleware.csrf import get_token
from django.http import JsonResponse
import pandas as pd
from rest_framework import status


EXASOL_CONNECTION_STRING = "exa+pyodbc://EXADB"


@api_view(['POST'])
@permission_classes([])
def excel_uploader(request):
    print('Hello, Im in excel_uploader')
    new_data = request.data.get('data', [])
    file_name = request.data.get('file')
    print(file_name)
    schema_name = request.data.get('schema')
    table_name = request.data.get('table')
    sheet_name = request.data.get('sheet')

    try:
        excel_columns = get_excel_columns(request.FILES['file'], sheet_name)
        print('#' * 10)
        print('excel columns')
        print(excel_columns)
        exasol_columns = get_exasol_columns(schema_name, table_name)
        print('*' * 10)
        print('EXASOL columns')
        print(exasol_columns)

        if exasol_columns == excel_columns:
            print('Data is successfully checked')
            data_to_send = read_data_from_excel(file_name, sheet_name)
            create_data_in_exasol(data_to_send, table_name, schema_name)
            response = {'message': 'Данные успешно выгружены.'}
            print('Printing response on create:', response)
        else:
            response = {
                'error': 'Название полей Excel и Базы данных не соответствуют друг другу.'}
            print('Название полей Excel и Базы данных не соответствуют друг другу.')

    except Exception as e:
        response = {'error': str(e)}
        print('Error in create operation:', response)

    return Response(response)

def get_exasol_columns(schema_name, table_name):
    print('Im in get_exasol_columns')
    print(schema_name)
    print(table_name)
    engine = create_engine("exa+pyodbc://EXADB")
    connection = engine.connect()

    sql_statement = text(
        """
        SELECT COLUMN_NAME
        FROM EXA_ALL_COLUMNS
        WHERE COLUMN_SCHEMA = :schema_name
        AND COLUMN_TABLE = :table_name
        """
    )

    result = connection.execute(
        sql_statement, schema_name=schema_name, table_name=table_name).fetchall()

    columns = [row[0] for row in result]

    connection.close()

    # print(columns)
    return columns


def get_excel_columns(file_path, sheet_name):
    # sheet_name = 'Мэппинг АВС'
    df = pd.read_excel(file_path, sheet_name=sheet_name)
    columns = df.columns.tolist()

    cleaned_columns = []
    for column in columns:
        cleaned_column = column.strip()
        # cleaned_column = cleaned_column.replace(' ', '_')
        cleaned_columns.append(cleaned_column)

    return cleaned_columns


def read_data_from_excel(file, sheet_name):
    df = pd.read_excel(file, sheet_name)
    data = df.to_dict(orient='records')

    return data


def create_data_in_exasol(data, table_name, schema_name, chunk_size=100):
    engine = create_engine(
        "exa+pyodbc://EXADB")

    metadata = MetaData(bind=engine)
    # metadata.reflect(schema=schema_name)

    print("data")
    print(data)

    columns = list(data[0].keys())
    # print('columns are:')
    # print(columns)

    connection = engine.connect()

    if not data:
        print("No data provided.")
        return

    processed_data = []
    for item in data:
        processed_item = {col.strip().replace(" ", "_"): None if str(
            value).lower() == 'nan' else value for col, value in item.items()}
        processed_data.append(processed_item)

    column_names = ", ".join(f'"{col.strip()}"' for col in columns)
    print('columns are:')
    print(column_names)
    value_placeholders = ", ".join(
        f':{col.strip().replace(" ", "_")}' for col in columns)

    sql_query = text(f"""
        INSERT INTO "{schema_name}"."{table_name}"
        ({column_names})
        VALUES
        ({value_placeholders})
    """)
    i = 0

    with engine.connect() as connection:
        trans = connection.begin()

        try:
            for i in range(0, len(processed_data), chunk_size):
                chunk = processed_data[i:i + chunk_size]
                connection.execute(sql_query, *chunk)

            trans.commit()
        except:
            trans.rollback()
            raise

    engine.dispose()


@api_view(['POST'])
@permission_classes([])
def retrieve_sheet_names(request):
    print('Im in retreive_sheet_names func')
    try:
        uploaded_file = request.FILES.get('excelFile')
        if not uploaded_file:
            return Response({'error': 'No file uploaded.'}, status=status.HTTP_400_BAD_REQUEST)

        excel_data = pd.ExcelFile(uploaded_file)
        sheet_names = excel_data.sheet_names

        return Response({'sheetNames': sheet_names}, status=status.HTTP_200_OK)
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
