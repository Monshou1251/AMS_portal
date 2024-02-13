from rest_framework.views import APIView
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from django.http import JsonResponse
import requests
# from airflow import DAG
# from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta, timezone

import time
import airflow_client.client
from airflow_client.client.api import connection_api
from airflow_client.client.model.connection import Connection
from airflow_client.client.model.connection_test import ConnectionTest
from airflow_client.client.model.error import Error
from pprint import pprint


# from rest_framework.response import response
# from rest_framework import status
import airflow_client.client
from airflow_client.client.api import config_api, dag_api, dag_run_api
from airflow_client.client.model.dag_run import DAGRun
from airflow_client.client import ApiClient
# from airflow_client.common.experimental.trigger_dag import trigger_dag
from airflow_client import client






@api_view(['GET', 'POST'])
@permission_classes([])
def trigger_time_delta(request):
    print('im in function')
 
    username = "IurchenkoGV"
    password = "sAMSUNG23"
    api_url = "https://z14-2330-af:4430/api/v1"
 
    session = requests.Session()
    session.verify = False
    session.auth = (username, password)
 
    dag_id = "test_time_delta_sensor"
 
    endpoint = f"/dags/{dag_id}/dagRuns"
    url = f"{api_url}{endpoint}"
 
    try:
        response = session.get(url, verify=False)
 
        if response.status_code == 200:
            dag_runs = response.json().get('dag_runs', [])
 
            if dag_runs:
                last_run = dag_runs[-1]
 
                if last_run.get('state') == 'running':
                    response_msg = 'The DAG is currently running.'
                else:
                    payload = {}  # Add any payload data if needed
                    trigger_response = session.post(url, json=payload, verify=False)
 
                    if trigger_response.status_code == 200:
                        response_msg = 'The DAG has been triggered successfully.'
                    else:
                        response_msg = 'Failed to trigger DAG.'
            else:
                response_msg = 'No DAG runs found.'
        else:
            response_msg = 'Failed to retrieve DAG information.'
    except requests.exceptions.RequestException as e:
        print(f"An error occurred: {str(e)}")
        response_msg = 'An error occurred during the request.'
 
    return JsonResponse({"message": response_msg})
         



    #         print("OK")
    #         print(response.text)
    #     else:
    #         print("NOT OKK")
    #         print(response.text)
    # except requests.exceptions.RequestException as e:
    #     print(f"An error occured: {str(e)}")

    # return Response(response.json())

    # _____________________________________________________________________________________


    # configuration = client.Configuration(
    #     host = "https://z14-2330-af:4430/api/v1",
    #     username = 'IurchenkoGV',
    #     password = 'sAMSUNG23',
    #     # verify_ssl = False,
    # )
    
    # with client.ApiClient(configuration) as api_client:
    #     api_instance = connection_api.ConnectionApi(api_client)
    #     connection = Connection() # Connection | 
    
    #     try:
    #         api_response = api_instance.test_connection(connection)
    #         pprint(api_response)
    #         response = api_response
    #     except client.ApiException as e:
    #         print("Exception when calling ConnectionApi->test_connection: %s\n" % e)
    #         response = "Exception when calling ConnectionApi->test_connection"
    
    # return Response(response)



    # api_client = ApiClient(api_base_url='http://z14-2330-af:4430/api/v1')
    # dag_id = 'test_time_delta_sensor'

    # response = trigger_dag(
    #     api_client=api_client,
    #     dag_id=dag_id,
    #     run_id='',
    #     execution_date=''
    # )

    # return response
    
    # configuration = airflow_client.client.Configuration(
    #     host="http://z14-2330-af:4430/api/v1/",
    #     username="IurchenkoGV",
    #     password="sAMSUNG23"
    # )
    # configuration = client.Configuration(
    #     host="http://z14-2330-af:4430/api/v1/",
    #     username="IurchenkoGV",
    #     password="sAMSUNG23"
    # )

    # with client.ApiClient(configuration) as api_client:
    #     api_instance = config_api.ConfigApi(api_client)
    #     section = ""

    #     try:
    #         api_response = api_instance.get_config()
    #         print(api_response)
    #     except client.ApiException as e:
    #         print("Exception when calling")

    # with airflow_client.client.ApiClient(configuration) as api_client:

    #     errors = False

    #     print('[blue]Getting DAG list')
    #     dag_api_instance = dag_api.DAGApi(api_client)
    #     try:
    #         api_response = dag_api_instance.get_dags()
    #         print(api_response)
    #     except airflow_client.client.OpenApiException as e:
    #         print('[red]Exception when calling DagAPI')
    #         error = True
    #     else:
    #         print('[green]Getting DAG list successful')
        
    # return ('O')


# Defining the host is optional and defaults to /api/v1
# See configuration.py for a list of all supported configuration parameters.

