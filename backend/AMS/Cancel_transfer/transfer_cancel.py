from rest_framework.exceptions import AuthenticationFailed
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from django.conf import settings
from django.core.cache import cache

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
#     'user': 'IurchenkoGV',
#     'password': 'Hahalala90!!!',
# }

YELLOW = '\033[93m'
RESET = '\033[0m'




@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_transfer_list(request):

    username = request.headers.get('X-Username', None)
    pyexasol_connection_key = f"pyexasol_connection_{username}"
    pyexasol_connection_string = cache.get(pyexasol_connection_key)

    try:
        with pyexasol.connect(**pyexasol_connection_string) as C:
            
            query = f'''
            SELECT *
            FROM AMS_GL.DGL_JOURNAL_INFO
            WHERE IS_ACTIVE=1
            AND ENTRIES_BATCH_TYPE = 'Проводки из Excel'
            ;
            '''

            result = C.execute(query).fetchall()
            C.commit()

            data = [
                {
                "ENTRIES_BATCH_CONTENT": row[4],
                "SOURCE_FILE_NAME": row[1],
                "SHEET_NAME": row[2],
                "USER_NAME": row[3],
                "LOAD_TIMESTAMP": row[7],
                "ROWS_COUNT": row[8],
                }
                for row in result
            ]
        
    except Exception as e:
        response = {'error':f'{str(e)}'}
        return Response(response)

    return Response({'message': data})


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def xlsx_deactivate(request):
    source_file_name = request.data.get('SOURCE_FILE_NAME')
    sheet_name = request.data.get('SHEET_NAME')
    user_name = request.data.get('USER_NAME')
    load_timestamp = request.data.get('LOAD_TIMESTAMP')

    username = request.headers.get('X-Username', None)
    pyexasol_connection_key = f"pyexasol_connection_{username}"
    pyexasol_connection_string = cache.get(pyexasol_connection_key)


    try:
        with pyexasol.connect(**pyexasol_connection_string) as C:

            # query = f'''EXECUTE SCRIPT "AMS_GL"."AMS_EXCEL_DGL_ENTRY_BUFFER_PROCESS"('{file_name}', '{sheet_name}', '{username}');'''
            query = f'''EXECUTE SCRIPT "AMS_GL"."AMS_DEACTIVATE_DGL_ENTRIES_PROCESS"('{source_file_name}', '{sheet_name}', '{user_name}', '{load_timestamp}')'''
            result = C.execute(query)
            C.commit()

    except Exception as e:
        response = {'error':f'{str(e)}'}
        return Response(response)

    

    return Response({'message':f'Выполнена деактивация загруженных из файла "{source_file_name}" проводок.'})
