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




@api_view(['POST'])
@permission_classes([IsAuthenticated])
def generate_transfer(request):

    username = request.headers.get('X-Username', None)
    pyexasol_connection_key = f"pyexasol_connection_{username}"
    date = request.data.get('date')
    print('date:', date)
    pyexasol_connection_string = cache.get(pyexasol_connection_key)

    try:
        with pyexasol.connect(**pyexasol_connection_string) as C:

            query = f'''EXECUTE SCRIPT "AMS_GL"."AMS_DGL_JRNL_CLOSE_PERIOD"('{date}')'''
            result = C.execute(query)
            C.commit()

    except Exception as e:
        response = {'error':f'{str(e)}'}
        return Response(response)

    return Response({'message':f'Проводка за {date} успешно сгенерирована'})
