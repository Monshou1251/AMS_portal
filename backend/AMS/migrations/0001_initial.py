# Generated by Django 4.2 on 2023-05-21 20:09

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='CdcStatus',
            fields=[
                ('id', models.BigAutoField(primary_key=True, serialize=False)),
                ('table_id', models.CharField(max_length=128)),
                ('last_read_seq', models.CharField(blank=True, max_length=35, null=True)),
                ('init_read_seq', models.CharField(blank=True, max_length=35, null=True)),
            ],
            options={
                'db_table': 'cdc_status',
                'ordering': ['-id'],
                'managed': True,
                'unique_together': {('table_id', 'id')},
            },
        ),
        migrations.CreateModel(
            name='CdcFields',
            fields=[
                ('id', models.BigAutoField(primary_key=True, serialize=False)),
                ('table_id', models.CharField(max_length=128)),
                ('source_field_name', models.CharField(max_length=128)),
                ('target_field_name', models.CharField(blank=True, max_length=128, null=True)),
                ('field_index', models.DecimalField(blank=True, decimal_places=0, max_digits=6, null=True)),
                ('field_type', models.CharField(blank=True, max_length=40, null=True)),
                ('modified_time', models.DateTimeField(blank=True, null=True)),
                ('pk_field', models.DecimalField(blank=True, db_column='pk', decimal_places=0, max_digits=10, null=True)),
                ('required', models.DecimalField(blank=True, decimal_places=0, max_digits=10, null=True)),
            ],
            options={
                'db_table': 'cdc_fields',
                'ordering': ['-id'],
                'managed': True,
                'unique_together': {('table_id', 'source_field_name', 'id')},
            },
        ),
        migrations.CreateModel(
            name='CdcConn',
            fields=[
                ('id', models.BigAutoField(primary_key=True, serialize=False)),
                ('conn_type', models.CharField(blank=True, max_length=128, null=True)),
                ('conn_name', models.CharField(max_length=128)),
            ],
            options={
                'db_table': 'cdc_conn',
                'ordering': ['-id'],
                'managed': True,
                'unique_together': {('conn_name', 'id')},
            },
        ),
    ]
