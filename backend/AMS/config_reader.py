import pandas as pd
import os 


def read_config_file():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    relative_path = "../../config.xls"
    file_path = os.path.join(script_dir, relative_path)
    # file_path = r'C:\App\config.xls'
    sheet_name = 'Лист1'

    df = pd.read_excel(file_path, sheet_name=sheet_name)

    data_to_send = {}
    for index, row in df.iterrows():
        table_id = row['TABLE_ID']
        field_name = row['FIELD_NAME']
        field_alias = row['FIELD_ALIAS']

        if pd.isnull(field_alias):
            field_alias = field_name

        if table_id not in data_to_send:
            data_to_send[table_id] = []

        data_to_send[table_id].append({field_name: field_alias})

    return data_to_send
