from rest_framework.exceptions import AuthenticationFailed
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated


from datetime import datetime
from datetime import timedelta
import openpyxl 
import pyexasol
import csv
import time




HOST = "10.106.11.200"
PORT = "8563"
# USER = "ATK_YURCHENKO"
USER = "atk_yurchenko"
PASS = "1234321"

@api_view(['POST'])
@permission_classes([])
# def xlsx_to_exa_table(**context):
def xlsx_to_exa_table(request):

    start_time = time.time()
    print('Hello, Im in excel_uploader (M version)')
    new_data = request.data.get('data', [])
    file_name = request.data.get('file')
    print(file_name)
    schema_name = request.data.get('schema')
    table_name = request.data.get('table')
    sheet_name = request.data.get('sheet')
    username = request.data.get('username')
    date = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    #данные из эксель добавляем в список rows.Получается список с tuples
    book = openpyxl.open(file_name, read_only = True, data_only = True)
    sheet = book[sheet_name]

    rows = []
    rows_count = 0

    for row in sheet.iter_rows(min_row=2):
        rows.append(tuple((file_name, sheet_name, username, date)+tuple([ str() if str(i.value) == 'None' else str(i.value) for i in row])))
        rows_count += 1

    #если rows не пустой, делаем транкейт и импорт в таблицу-приемник
    if len(rows) > 0:

        try:
            C  = pyexasol.connect(dsn = f"{HOST}:{PORT}", user=USER, password=PASS)
            C.set_autocommit(False)
            C.open_schema(schema_name)
            print('Executing query...')
            C.execute(f"TRUNCATE TABLE {schema_name}.{table_name}")
            C.commit()
            print('Query executed')

            C.import_from_iterable(rows, table_name)
            print(f'{rows_count} строк обработано')
            rows.clear()
            
            C.commit()
            C.close()
            end_time = time.time()
            execution_time_overall = end_time - start_time
            response = {'message': f'Данные успешно выгружены. Затраченное время: {execution_time_overall}'}
        except Exception as e:
                print(f"Error: {e}")
                response = {'error': str(e)}
                raise


        # return rows_count

    return Response(response)

# with DAG('test_xlsx_load',
#          tags=["antonovams", "alfains"],
#          default_args=args,
#          description='Dag',
#          catchup=False,
#          max_active_runs=1,
#          params = {"file_path": f'{Variable.get("FILE_DATA_DIR")}/AMS/', 
#                    "file_name": "XLSX_DGL_ENTRY",
#                    "sheet_name":"XLSX_DGL_ENTRY", 
#                    "db_schema":"TEST_XLSX_LOAD", 
#                    "table":"XLSX_DGL_BUFFER"},
#          start_date= datetime(2023,10,22)
#     ) as dag:
    
#     start = EmptyOperator(task_id = "start") 
#     end = EmptyOperator(task_id = "end")
    
#     load_XLSX_into_table = PythonOperator(
#         task_id='load_XLSX_into_table',
#         python_callable = xlsx_to_exa_table,
#         op_kwargs = {"file_path": "{{params.file_path}}", 
#                      "file_name": "{{params.file_name}}",
#                      "date":datetime.now().strftime("%Y-%m-%d %H:%M:%S"), 
#                      "sheet_name":"{{params.sheet_name}}", 
#                      "db_schema":"{{params.db_schema}}", 
#                      "table":"{{params.table}}", 
#                      "host": "{{conn.exasol7.host}}", 
#                      "port": "{{conn.exasol7.port}}",
#                      "login":"{{conn.exasol7.login}}", 
#                      "password":"{{conn.exasol7.password}}" },
#         provide_context=True
#     )

    

# start>> load_XLSX_into_table>> end

