from rest_framework.exceptions import AuthenticationFailed
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from django.core.cache import cache


from datetime import datetime
from datetime import timedelta
import openpyxl 
import pyexasol
import csv
import time
import pandas as pd




# HOST = "10.106.11.200"
# PORT = "8563"
# USER = "atk_yurchenko"
# PASS = "1234321"

# CONNECTION_PARAMS = {
#     'dsn': f"{HOST}:{PORT}",
#     'user': USER,
#     'password': PASS,
# }

YELLOW = '\033[93m'
RESET = '\033[0m'


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

    username = request.headers.get('X-Username', None)
    pyexasol_connection_key = f"pyexasol_connection_{username}"
    pyexasol_connection_string = cache.get(pyexasol_connection_key)

    
    #excel to pandas
    df_excel = pd.read_excel(file_name, sheet_name = sheet_name, dtype = str)

    #получаем названия всех колонок из таблицы приёмника
    C = pyexasol.connect(**pyexasol_connection_string)
    C.set_autocommit(False)
    table_columns = C.execute(f"select COLUMN_NAME from EXA_ALL_COLUMNS where COLUMN_SCHEMA = 'AMS_GL' and COLUMN_TABLE = 'XLSX_DGL_BUFFER';")
    C.commit()
    
    must_be_cols = ['ENTRY_DATE', 'GL_ACCOUNT_DT','GL_ACCOUNT_CR', 'AMOUNT', 'AMOUNT_BASE' , 'CURRENCY', 'LINE_ID']
    tab_cols = table_columns.fetchcol()[4:] #список колонок таблицы приёмника за исключением колонок с мета данными
    exc_cols = df_excel.columns.tolist() #список колонок из эксель файла

    not_in_list = [element for element in must_be_cols if element not in exc_cols]
    print(not_in_list)

    #проверяем есть ли обязательные колонки в списке колонок эксель 
    if (set(must_be_cols)).issubset(set(exc_cols)) == True:
            
        if  len([i for i in exc_cols if i not in tab_cols]) == 0:

            df_empty = pd.DataFrame(columns = tab_cols)
            df_full = pd.concat([df_empty,df_excel])

            try:
                df_full['ENTRY_DATE'] = pd.to_datetime(df_full.ENTRY_DATE).dt.strftime('%d.%m.%Y')
                #dataframe с мета данными(первые 4 колонки таблицы-приёмника)
                df_first_columns = ['SOURCE_FILE_NAME', 'SHEET_NAME' ,'USER_NAME', 'LOAD_TIMESTAMP']
                df_first = pd.DataFrame([[file_name, sheet_name, username, date] for i in range(len(df_excel))], columns=df_first_columns)
                    
                #объединяем датафреймы
                df = pd.concat([df_first,df_full] , axis=1)
    
                #очистка таблицы приёмника
                C = pyexasol.connect(**pyexasol_connection_string)
                C.set_autocommit(False)
                C.open_schema(schema_name)
                # C.execute(f"TRUNCATE TABLE {schema_name}.{table_name}")
                # C.commit()

                #загрузка общего датафрейма в таблицу приёмник
                C.import_from_pandas(df, table_name)
                C.commit()
                C.close()

                response = {'message': f'Данные успешно загружены. Количество загруженных строк: {len(df)}.'}
            except:
                # print("В колонке ENTRY_DATE есть значения не в формате дата")
                response = {'error': "В колонке ENTRY_DATE есть значения не в формате дата"}
            

        elif len([i for i in exc_cols if i not in tab_cols]) > 0:
            #удаляем колонки названий которых нет таблице приёмнике
            df_excel = df_excel.drop(columns = [i for i in exc_cols if i not in tab_cols])
            df_empty = pd.DataFrame(columns = tab_cols)
            df_full = pd.concat([df_empty,df_excel])

            try:
                df_full['ENTRY_DATE'] = pd.to_datetime(df_full.ENTRY_DATE).dt.strftime('%d.%m.%Y')
                #dataframe с мета данными(первые 4 колонки таблицы-приёмника)
                df_first_columns = ['SOURCE_FILE_NAME', 'SHEET_NAME' ,'USER_NAME', 'LOAD_TIMESTAMP']
                df_first = pd.DataFrame([[file_name, sheet_name, username, date] for i in range(len(df_excel))], columns=df_first_columns)
                    
                #объединяем датафреймы
                df = pd.concat([df_first,df_full] , axis=1)
    
                #очистка таблицы приёмника
                C = pyexasol.connect(**pyexasol_connection_string)
                C.set_autocommit(False)
                C.open_schema(schema_name)
                # C.execute(f"TRUNCATE TABLE {schema_name}.{table_name}")
                # C.commit()

                #загрузка общего датафрейма в таблицу приёмник
                C.import_from_pandas(df, table_name)
                C.commit()
                C.close()

                # print('Эти колонки не будут загружены ', [i for i in exc_cols if i not in tab_cols])

                message = ', '.join([i for i in exc_cols if i not in tab_cols])

                response = {
                    'message': f'Выполнена загрузка проводок в буферную таблицу. \
                    Количество загруженных из файла строк: {len(df)}. \
                    Следующие колонки в выбранном файле не были загружены: {message}.'
                }
            except:
                response = {'error': "В колонке ENTRY_DATE есть значения не в формате дата"}

    else:
        response = {'message': 'Нет всех обязательных колонок ENTRY_DATE, GL_ACCOUNT_DT, GL_ACCOUNT_CR, AMOUNT, AMOUNT_BASE, CURRENCY, LINE_ID'}

    return Response(response)


@api_view(['POST'])
@permission_classes([])
# def xlsx_to_exa_table(**context):
def xlsx_to_exa_table_check(request):
    start_time = time.time()
    print('Hello, Im in xlsx_to_exa_table_check')
    new_data = request.data.get('data', [])
    file_name = request.data.get('file')
    print(file_name)
    schema_name = request.data.get('schema')
    table_name = request.data.get('table')
    sheet_name = request.data.get('sheet')
    username = request.data.get('username')
    date = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    username = request.headers.get('X-Username', None)
    pyexasol_connection_key = f"pyexasol_connection_{username}"
    pyexasol_connection_string = cache.get(pyexasol_connection_key)
    

    scripts = {
        "AMS_GL.CHECK_LINE_ID_IS_NOT_EMPTY": f"В загруженных данных есть {{result}}, где поле LINE_ID не заполнено",
        "AMS_GL.CHECK_LINE_ID_IS_FLOAT": f"В загруженных данных есть {{result}}, где значение в поле LINE_ID не является числом",
        "AMS_GL.CHECK_LINE_ID_IS_NOT_ZERO": f"В загруженных данных есть {{result}}, где значение в поле LINE_ID равно 0",
        "AMS_GL.CHECK_LINE_ID_DOUBLES_NOT_EXIST": f"В загруженных данных есть {{result}}, где значение в поле LINE_ID является неуникальным",
        "AMS_GL.CHECK_LINE_ID_ROUND": f"В загруженных данных есть {{result}}, где значение в поле LINE_ID не является целым числом",
        "AMS_GL.CHECK_ENTRY_DATE_IS_NOT_EMPTY": f"В загруженных данных есть {{result}}, где поле ENTRY_DATE не заполнено",
        "AMS_GL.CHECK_ENTRY_DATE_FORMAT": f"В загруженных данных есть {{result}}, где значение в поле ENTRY_DATE не соответствует формату даты ДД.ММ.ГГГГ",
        "AMS_GL.CHECK_ENTRY_DATE_IN_OPEN_PER": f"В загруженных данных есть {{result}}, где значение даты в поле ENTRY_DATE не относится к открытому периоду",
        "AMS_GL.CHECK_GL_ACCOUNT_DT_IS_NOT_EMPTY": f"В загруженных данных есть {{result}}, где поле GL_ACCOUNT_DT не заполнено",
        "AMS_GL.CHECK_GL_ACCOUNT_CR_IS_NOT_EMPTY": f"В загруженных данных есть {{result}}, где поле GL_ACCOUNT_CR не заполнено",
        "AMS_GL.CHECK_GL_ACCOUNTS_2_DT_CR_NOT_EMPTY": f"В загруженных данных есть {{result}}, где GL_ACCOUNT_2 указан только на одной стороне проводки",
        "AMS_GL.CHECK_AMOUNT_BASE_IS_NOT_EMPTY": f"В загруженных данных есть {{result}}, где поле AMOUNT_BASE не заполнено",
        "AMS_GL.CHECK_AMOUNT_BASE_IS_FLOAT": f"В загруженных данных есть {{result}}, где значение в поле AMOUNT_BASE не является числом",
        # "AMS_GL.CHECK_AMOUNT_BASE_IS_NOT_ZERO": f"В загруженных данных есть {{result}}, где значение в поле AMOUNT_BASE равно 0",
        "AMS_GL.CHECK_AMOUNT_BASE_ROUND": f"В загруженных данных есть {{result}}, где в значении суммы в поле AMOUNT_BASE количество знаков после запятой больше 2-х",
        "AMS_GL.CHECK_CURRENCY_VALUE_EXIST": f"В загруженных данных есть {{result}}, где поле CURRENCY содержит значение кода валюты, которое отсутствует в справочнике валют AMS_GL.CURRENCY",
        "AMS_GL.CHECK_AMOUNT_IS_NOT_EMPTY": f"В загруженных данных есть {{result}}, где в поле CURRENCY указан отличный от RUR код валюты и поле AMOUNT не заполнено",
        "AMS_GL.CHECK_AMOUNT_IS_FLOAT": f"В загруженных данных есть {{result}}, где значение в поле AMOUNT не является числом",
        "AMS_GL.CHECK_AMOUNT_ROUND": f"В загруженных данных есть {{result}}, где в значении суммы в поле AMOUNT количество знаков после запятой больше 2-х",
        "AMS_GL.CHECK_AMOUNT_NU_IS_FLOAT": f"В загруженных данных есть {{result}}, где значение в поле AMOUNT_NU не является числом",
        "AMS_GL.CHECK_AMOUNT_NU_ROUND": f"В загруженных данных есть {{result}}, где в значении суммы в поле AMOUNT_NU количество знаков после запятой больше 2-х",
        "AMS_GL.CHECK_AMOUNT_VR_IS_FLOAT": f"В загруженных данных есть {{result}}, где значение в поле AMOUNT_VR не является числом",
        "AMS_GL.CHECK_AMOUNT_VR_ROUND": f"В загруженных данных есть {{result}}, где в значении суммы в поле AMOUNT_VR количество знаков после запятой больше 2-х",
        "AMS_GL.CHECK_AMOUNT_PR_IS_FLOAT": f"В загруженных данных есть {{result}}, где значение в поле AMOUNT_PR не является числом",
        "AMS_GL.CHECK_AMOUNT_PR_ROUND": f"В загруженных данных есть {{result}}, где в значении суммы в поле AMOUNT_PR количество знаков после запятой больше 2-х",
        "AMS_GL.CHECK_GL_ACCOUNT_DT_VALUE_EXIST": f"В загруженных данных есть {{result}}, где поле GL_ACCOUNT_DT содержит значение номера счёта, которое отсутствует в таблице плана счетов 1С AMS_GL.GL_ACCOUNT",
        "AMS_GL.CHECK_GL_ACCOUNT_CR_VALUE_EXIST": f"В загруженных данных есть {{result}}, где поле GL_ACCOUNT_CR содержит значение номера счёта, которое отсутствует в таблице плана счетов 1С AMS_GL.GL_ACCOUNT",
        "AMS_GL.CHECK_GL_ACCOUNT_2_DT_VALUE_EXIST": f"В загруженных данных есть {{result}}, где поле GL_ACCOUNT_2_DT содержит значение номера счёта, которое отсутствует в таблице 2-х значного плана счетов AMS_GL.GL_ACCOUNT_2",
        "AMS_GL.CHECK_GL_ACCOUNT_2_CR_VALUE_EXIST": f"В загруженных данных есть {{result}}, где поле GL_ACCOUNT_2_CR содержит значение номера счёта, которое отсутствует в таблице 2-х значного плана счетов AMS_GL.GL_ACCOUNT_2",
        "AMS_GL.CHECK_INS_CONTRACT_ID_VALUE_EXIST": f"В загруженных данных есть {{result}}, где поле INS_CONTRACT_ID содержит значение ID страхового договора, которое отсутствует в поле AMS_1C_CODE в таблице договоров AMS_GL.INS_CONTRACT",
        "AMS_GL.CHECK_REINS_CONTRACT_ID_VALUE_EXIST": f"В загруженных данных есть {{result}}, где поле REINS_CONTRACT_ID содержит значение ID договора перестрахования, которое отсутствует в поле AMS_1C_CODE в таблице договоров AMS_GL.INS_CONTRACT",
        "AMS_GL.CHECK_INS_POLICY_ID_VALUE_EXIST": f"В загруженных данных есть {{result}}, где поле INS_POLICY_ID содержит значение ID страхового полиса, которое отсутствует в поле AMS_1C_CODE в таблице страховых полисов AMS_GL.INS_POLICY",
        "AMS_GL.CHECK_CLAIM_STATEMENT_ID_VALUE_EXIST": f"В загруженных данных есть {{result}}, где поле CLAIM_STATEMENT_ID содержит значение ID дела по убытку, которое отсутствует в поле AMS_1C_CODE в таблице дел по убытку AMS_GL.CLAIM_STATEMENT",
        "AMS_GL.CHECK_DEPARTMENT_DT_VALUE_EXIST": f"В загруженных данных есть {{result}}, где поле DEPARTMENT_DT содержит значение кода подразделения, которое отсутствует в поле AMS_1C_CODE в таблице справочника подразделений AMS_GL.DEPARTMENT",
        "AMS_GL.CHECK_DEPARTMENT_CR_VALUE_EXIST": f"В загруженных данных есть {{result}}, где поле DEPARTMENT_CR содержит значение кода подразделения, которое отсутствует в поле AMS_1C_CODE в таблице справочника подразделений AMS_GL.DEPARTMENT",
        "AMS_GL.CHECK_PL_ITEM_DT_VALUE_EXIST": f"В загруженных данных есть {{result}}, где поле PL_CODE_DT содержит значение кода прочих доходов и расходов, которое отсутствует в поле AMS_1C_CODE в таблице справочника прочих доходов и расходов AMS_GL.PL_CODE",
        "AMS_GL.CHECK_PL_ITEM_CR_VALUE_EXIST": f"В загруженных данных есть {{result}}, где поле PL_CODE_CR содержит значение кода прочих доходов и расходов, которое отсутствует в поле AMS_1C_CODE в таблице справочника прочих доходов и расходов AMS_GL.PL_CODE",
        "AMS_GL.CHECK_SETTLEMENT_TYPE_CR_VALUE_EXIST": f"В загруженных данных есть {{result}}, где поле ST_TYPE_DT содержит значение кода видов расчетов по страховым операциям, которое отсутствует в поле AMS_1C_CODE в таблице справочника видов расчетов по страховым операциям AMS_GL.SETTLEMENT_TYPE",
        "AMS_GL.CHECK_SETTLEMENT_TYPE_DT_VALUE_EXIST": f"В загруженных данных есть {{result}}, где поле ST_TYPE_CR содержит значение кода видов расчетов по страховым операциям, которое отсутствует в поле AMS_1C_CODE в таблице справочника видов расчетов по страховым операциям AMS_GL.SETTLEMENT_TYPE",
        "AMS_GL.CHECK_SUBJECT_1C_DT_VALUE_EXIST": f"В загруженных данных есть {{result}}, где поле SUBJECT_1C_DT содержит значение наименования контрагента 1С, которое отсутствует в поле AMS_1C_CODE в таблице справочника контрагентов AMS_GL.SUBJECT",
        "AMS_GL.CHECK_SUBJECT_1C_CR_VALUE_EXIST": f"В загруженных данных есть {{result}}, где поле SUBJECT_1C_CR содержит значение наименования контрагента 1С, которое отсутствует в поле AMS_1C_CODE в таблице справочника контрагентов AMS_GL.SUBJECT",
        "AMS_GL.CHECK_TOC_DT_VALUE_EXIST": f"В загруженных данных есть {{result}}, где поле TOC_DT содержит значение кода ТОС, которое отсутствует в поле AMS_1C_CODE в таблице справочника ТОС AMS_GL.INS_OBJECT_TYPE",
        "AMS_GL.CHECK_TOC_CR_VALUE_EXIST": f"В загруженных данных есть {{result}}, где поле TOC_CR содержит значение кода ТОС, которое отсутствует в поле AMS_1C_CODE в таблице справочника ТОС AMS_GL.INS_OBJECT_TYPE",
        "AMS_GL.CHECK_SUBJECT_ID_DT_VALUE_EXIST": f"В загруженных данных есть {{result}}, где поле SUBJECT_ID_DT содержит значение ID контрагента, которое отсутствует в поле AMS_1C_CODE в таблице справочника контрагентов AMS_GL.SUBJECT",
        "AMS_GL.CHECK_SUBJECT_ID_CR_VALUE_EXIST": f"В загруженных данных есть {{result}}, где поле SUBJECT_ID_CR содержит значение ID контрагента, которое отсутствует в поле AMS_1C_CODE в таблице справочника контрагентов AMS_GL.SUBJECT",
        "AMS_GL.CHECK_BUSINESS_LINE_DT_VALUE_EXIST": f"В загруженных данных есть {{result}}, где поле BUSINESS_LINE_DT содержит значение кода линии бизнеса, которое отсутствует в поле AMS_1C_CODE в таблице справочника линий бизнеса AMS_GL.BUSINESS_LINE",
        "AMS_GL.CHECK_BUSINESS_LINE_CR_VALUE_EXIST": f"В загруженных данных есть {{result}}, где поле BUSINESS_LINE_CR содержит значение кода линии бизнеса, которое отсутствует в поле AMS_1C_CODE в таблице справочника линий бизнеса AMS_GL.BUSINESS_LINE",
        "AMS_GL.CHECK_COOLOFF_PARTNER_DT_VALUE_EXIST": f"В загруженных данных есть {{result}}, где поле COOLOFF_PARTNER_DT содержит составной ключ, состоящий из комбинации 2-х полей: код COOLOFF Партнёра|наименование COOLOFF Партнёра, которые отсутствуют в поле AMS_INTEGR_CODE в таблице справочника COOLOFF Партнёров AMS_GL.COOLOFF_PARTNER",
        "AMS_GL.CHECK_COOLOFF_PARTNER_CR_VALUE_EXIST": f"В загруженных данных есть {{result}}, где поле COOLOFF_PARTNER_CR содержит составной ключ, состоящий из комбинации 2-х полей: код COOLOFF Партнёра|наименование COOLOFF Партнёра, которые отсутствуют в поле AMS_INTEGR_CODE в таблице справочника COOLOFF Партнёров AMS_GL.COOLOFF_PARTNER",
        "AMS_GL.CHECK_COOLOFF_PRODUCT_DT_VALUE_EXIST": f"В загруженных данных есть {{result}}, где поле COOLOFF_PRODUCT_DT содержит составной ключ, состоящий из комбинации 2-х полей: код COOLOFF Продукта|наименование COOLOFF Продукта, которые отсутствуют в поле AMS_INTEGR_CODE в таблице справочника COOLOFF Продуктов AMS_GL.COOLOFF_PRODUCT",
        "AMS_GL.CHECK_COOLOFF_PRODUCT_CR_VALUE_EXIST": f"В загруженных данных есть {{result}}, где поле COOLOFF_PRODUCT_CR содержит составной ключ, состоящий из комбинации 2-х полей: код COOLOFF Продукта|наименование COOLOFF Продукта, которые отсутствуют в поле AMS_INTEGR_CODE в таблице справочника COOLOFF Продуктов AMS_GL.COOLOFF_PRODUCT",
        "AMS_GL.CHECK_PAYDOC_DT_VALUE_EXIST": f"В загруженных данных есть {{result}}, где поле PAYDOC_DT содержит составной ключ, состоящий из комбинации 3-х полей: код типа платёжного документа|номер платёжного документа|дата платёжного документа, которые отсутствуют в поле AMS_INTEGR_CODE в таблице справочника Платёжных документов AMS_GL.PAYDOC",
        "AMS_GL.CHECK_PAYDOC_CR_VALUE_EXIST": f"В загруженных данных есть {{result}}, где поле PAYDOC_CR содержит составной ключ, состоящий из комбинации 3-х полей: код типа платёжного документа|номер платёжного документа|дата платёжного документа, которые отсутствуют в поле AMS_INTEGR_CODE в таблице справочника Платёжных документов AMS_GL.PAYDOC",
    }

    # Функция-обработчик корректного вывода количества строк с ошибками
    def lines_count_txt_rus(rows_count):
        if rows_count < 11 or rows_count > 14:
            if rows_count % 10 == 1:
                return f'{rows_count} строка'
            elif 2 <= rows_count % 10 <= 4:
                return f'{rows_count} строки'
            else:
                return f'{rows_count} строк'
        elif 11 <= rows_count <= 14:
            return f'{rows_count} строк'

    try:
        with pyexasol.connect(**pyexasol_connection_string) as C:
            for script, error_message_template in scripts.items():
                query = f'''EXECUTE SCRIPT {script}('{file_name}', '{sheet_name}', '{username}');'''
            
                result = C.execute(query).fetchall()[0][0]
                # records = 
                C.commit()

                if result > 0:
                    lines_count_txt = lines_count_txt_rus(result)
                    error_message = error_message_template.format(result=lines_count_txt)
                    raise Exception(error_message)
           
    except Exception as e:
        response = {'error':f'{str(e)}'}
        return Response(response)

    return Response({'message':f'При проверке в загруженных в буферную таблицу проводках ошибки не найдены.'})



@api_view(['POST'])
@permission_classes([])
# def xlsx_to_exa_table(**context):
def xlsx_to_exa_table_push(request):
    new_data = request.data.get('data', [])
    file_name = request.data.get('file')
    schema_name = request.data.get('schema')
    table_name = request.data.get('table')
    sheet_name = request.data.get('sheet')
    # username = request.data.get('username')
    batch_content = request.data.get('batch')
    print("__"*20)
    print(batch_content)
    print("__"*20)


    username = request.headers.get('X-Username', None)
    pyexasol_connection_key = f"pyexasol_connection_{username}"
    pyexasol_connection_string = cache.get(pyexasol_connection_key)

    
    try:
        with pyexasol.connect(**pyexasol_connection_string) as C:

            query = f'''EXECUTE SCRIPT "AMS_GL"."AMS_EXCEL_DGL_ENTRY_BUFFER_PROCESS"('{file_name}', '{sheet_name}', '{username}', '{batch_content}');'''
            result = C.execute(query).fetchall()
            # C.commit()

            if result[0][0] > 0:
                    error_message = result[0][1]
                    raise Exception(error_message)

           
    except Exception as e:
        response = {'error':f'{str(e)}'}
        return Response(response)

    

    return Response({'message':f'Загрузка проводок из буферной таблицы в детальную главную книгу выполнена.'})



@api_view(['POST'])
@permission_classes([])
def xlsx_to_exa_check_buffer(request):
    file_name = request.data.get('file')
    schema_name = request.data.get('schema')
    table_name = request.data.get('table')
    sheet_name = request.data.get('sheet')
    # username = request.data.get('username')

    username = request.headers.get('X-Username', None)
    pyexasol_connection_key = f"pyexasol_connection_{username}"
    pyexasol_connection_string = cache.get(pyexasol_connection_key)

    
    try:
        with pyexasol.connect(**pyexasol_connection_string) as C:
            
            query = f'''
            SELECT
                SOURCE_FILE_NAME, 
                SHEET_NAME, 
                USER_NAME, 
                LOAD_TIMESTAMP, 
                LINE_ID, 
                ENTRY_DATE, 
                GL_ACCOUNT_2_DT, 
                GL_ACCOUNT_2_CR, 
                GL_ACCOUNT_DT, 
                GL_ACCOUNT_CR, 
                CURRENCY, 
                INS_CONTRACT_ID, 
                REINS_CONTRACT_ID, 
                INS_POLICY_ID, 
                CLAIM_STATEMENT_ID, 
                DEPARTMENT_DT, 
                DEPARTMENT_CR, 
                AMOUNT, 
                AMOUNT_BASE, 
                AMOUNT_NU, 
                AMOUNT_VR, 
                AMOUNT_PR, 
                OPERATION_CONTENT, 
                PL_CODE_DT, 
                PL_CODE_CR, 
                SETTLEMENT_TYPE_DT, 
                SETTLEMENT_TYPE_CR, 
                SUBJECT_1C_DT, 
                SUBJECT_1C_CR, 
                TOC_DT, 
                TOC_CR, 
                SUBJECT_ID_DT, 
                SUBJECT_ID_CR, 
                BUSINESS_LINE_DT, 
                BUSINESS_LINE_CR, 
                COOLOFF_PARTNER_DT, 
                COOLOFF_PARTNER_CR, 
                COOLOFF_PRODUCT_DT, 
                COOLOFF_PRODUCT_CR, 
                PAYDOC_DT, 
                PAYDOC_CR
            FROM
                AMS_GL.XLSX_DGL_BUFFER
            where SOURCE_FILE_NAME = '{file_name}' and SHEET_NAME = '{sheet_name}' and USER_NAME = '{username}'
            ;
            '''

            result = C.execute(query).fetchall()
            # C.commit()

            rows = len(result)
        
    except Exception as e:
        response = {'error':f'{str(e)}'}
        return Response(response)

    return Response({'message': rows})


@api_view(['POST'])
@permission_classes([])
def xlsx_to_exa_check_DGL_ENTRY(request):
    file_name = request.data.get('file')
    schema_name = request.data.get('schema')
    table_name = request.data.get('table')
    sheet_name = request.data.get('sheet')
    # username = request.data.get('username')

    username = request.headers.get('X-Username', None)
    pyexasol_connection_key = f"pyexasol_connection_{username}"
    pyexasol_connection_string = cache.get(pyexasol_connection_key)

    print('pyexasol_connection_string')
    print(pyexasol_connection_string)

    
    try:
        with pyexasol.connect(**pyexasol_connection_string) as C:
            
            query = f'''
            SELECT COUNT(*) FROM AMS_GL.DGL_ENTRY DE
                INNER JOIN AMS_GL.DGL_JOURNAL_ENTRY FE ON FE.DGL_JOURNAL_ENTRY_SID = DE.SOURCE_ID AND DE.SYSTEM_SID = 18
                INNER JOIN AMS_GL.DGL_JOURNAL_INFO FI ON FI.DGL_JOURNAL_INFO_SID = FE.DGL_JOURNAL_INFO_SID
                AND FI.SOURCE_FILE_NAME = '{file_name}'
                AND FI.SHEET_NAME = '{sheet_name}'
                AND FI.USER_NAME = '{username}'
            ;
            '''

            result = C.execute(query).fetchall()[0][0]
            C.commit()

            print(f'{YELLOW} im in check buffer {RESET}')
            print('result: ', result)

            # rows = len(result)
        
    except Exception as e:
        print('Erroe caught: ', str(e))
        response = {'error':f'{str(e)}'}
        return Response(response)

    return Response({'message': result})


@api_view(['POST'])
@permission_classes([])
def xlsx_to_exa_delete_from_buffer(request):
    file_name = request.data.get('file')
    schema_name = request.data.get('schema')
    table_name = request.data.get('table')
    sheet_name = request.data.get('sheet')
    # username = request.data.get('username')

    username = request.headers.get('X-Username', None)
    pyexasol_connection_key = f"pyexasol_connection_{username}"
    pyexasol_connection_string = cache.get(pyexasol_connection_key)
    
    try:
        with pyexasol.connect(**pyexasol_connection_string) as C:
            
            query = f'''
            DELETE FROM AMS_GL.XLSX_DGL_BUFFER
            WHERE
            USER_NAME = '{username}'
            ;
            '''
            # query = f'''
            # DELETE FROM AMS_GL.XLSX_DGL_BUFFER
            # WHERE SOURCE_FILE_NAME = '{file_name}'
            # AND SHEET_NAME = '{sheet_name}'
            # AND USER_NAME = '{username}'
            # ;
            # '''

            result = C.execute(query)
            C.commit()
        
    except Exception as e:
        response = {'error':f'{str(e)}'}
        return Response(response)

    return Response({'message': 'Загруженные пользователем старые данные были удалены из буферной таблицы.'})