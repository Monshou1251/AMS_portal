from AMS.models import *

# def CdcConn_add():
#     data_list = [
#         {'conn_type': 'Value 2', 'conn_name': 'Value 2'},
#         {'conn_type': 'Value 3', 'conn_name': 'Value 3'},
#         {'conn_type': 'Value 4', 'conn_name': 'Value 4'},
#         {'conn_type': 'Value 5', 'conn_name': 'Value 5'},
#         {'conn_type': 'Value 6', 'conn_name': 'Value 6'},
#         # Add more dictionaries representing the data you want to add
#     ]

#     # Loop through the data list and create/save objects
#     for data in data_list:
#         my_object = CdcConn(**data)
#         my_object.save()

data_list = [
    {'table_id': 'Value 1', 'last_read_seq': 'Value 1', 'init_read_seq': 'Value 1'},
    {'table_id': 'Value 2', 'last_read_seq': 'Value 2', 'init_read_seq': 'Value 2'},
    {'table_id': 'Value 3', 'last_read_seq': 'Value 3', 'init_read_seq': 'Value 3'},
    {'table_id': 'Value 4', 'last_read_seq': 'Value 4', 'init_read_seq': 'Value 4'},
    {'table_id': 'Value 5', 'last_read_seq': 'Value 5', 'init_read_seq': 'Value 5'},
    {'table_id': 'Value 6', 'last_read_seq': 'Value 6', 'init_read_seq': 'Value 6'},
]

for data in data_list:
    my = CdcStatus(**data)
    my.save()