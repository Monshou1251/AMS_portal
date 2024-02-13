from django.urls import path, include
from .views import set_exasol_credentials, user_access_put_view, user_access_view, user_permissions_view, exasol_data_view, exasol_data_create, exasol_data_delete, exasol_data_update
from .Excel_uploader.excel_uploader import excel_uploader, retrieve_sheet_names
from .Excel_uploader.excel_uploader_v2 import excel_uploader_v2
from .Excel_uploader.xlsx_to_exa_table import xlsx_to_exa_delete_from_buffer, xlsx_to_exa_check_DGL_ENTRY, xlsx_to_exa_table, xlsx_to_exa_table_check, xlsx_to_exa_table_push
from .Cancel_transfer.transfer_cancel import get_transfer_list, xlsx_deactivate
from .Cancel_transfer.transfer_cancel_ams import get_transfer_list_ams, xlsx_deactivate_ams
from .Cancel_transfer.generate_transfer import generate_transfer
from .airflowTrigger import trigger_time_delta
from rest_framework import routers


router = routers.DefaultRouter()

urlpatterns = [
    path('', include(router.urls)),
    path('exasol-data/', exasol_data_view, name='exasol_data'),
    path('set_exasol_credentials/', set_exasol_credentials, name='set_exasol_credentials'),
    path('user_access_view/', user_access_view, name='user_access_view'),
    path('user_permissions/<str:username>/',
         user_permissions_view, name='user_permissions_view'),
    path('exasol_data_delete/', exasol_data_delete, name='exasol_data_delete'),
    path('excel_uploader', excel_uploader, name='excel_uploader'),
    path('get_transfer_list', get_transfer_list, name='get_transfer_list'),
    path('xlsx_deactivate', xlsx_deactivate, name='xlsx_deactivate'),

    path('get_transfer_list_ams', get_transfer_list_ams, name='get_transfer_list_ams'),
    path('xlsx_deactivate_ams', xlsx_deactivate_ams, name='xlsx_deactivate_ams'),
    path('generate_transfer', generate_transfer, name='generate_transfer'),

    path('excel_uploader_v2', excel_uploader_v2, name='excel_uploader_v2'),
    path('xlsx_to_exa_table', xlsx_to_exa_table, name='xlsx_to_exa_table'),
    path('xlsx_to_exa_table_check', xlsx_to_exa_table_check, name='xlsx_to_exa_table_check'),
    path('xlsx_to_exa_table_push', xlsx_to_exa_table_push, name='xlsx_to_exa_table_push'),
    path('xlsx_to_exa_check_DGL_ENTRY', xlsx_to_exa_check_DGL_ENTRY, name='xlsx_to_exa_check_DGL_ENTRY'),
    path('xlsx_to_exa_delete_from_buffer', xlsx_to_exa_delete_from_buffer, name='xlsx_to_exa_delete_from_buffer'),
    path('retrieve_sheet_names', retrieve_sheet_names,
         name='retrieve_sheet_names'),
    path('exasol_data_update', exasol_data_update, name='exasol_data_update'),
    path('exasol_data_create', exasol_data_create, name='/exasol_data_create'),
    path('user_access_put_view', user_access_put_view,
         name='user_access_put_view'),
    path('trigger_time_delta', trigger_time_delta, name='trigger_time_delta'),
]
