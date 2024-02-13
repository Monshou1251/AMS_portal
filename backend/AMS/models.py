from django.contrib.auth.models import User

from django.db import models


class CdcConn(models.Model):
    id = models.BigAutoField(primary_key=True)
    conn_type = models.CharField(max_length=128, blank=True, null=True)
    conn_name = models.CharField(max_length=128)

    class Meta:
        managed = True
        db_table = 'cdc_conn'
        ordering = ['-id']
        unique_together = (('conn_name', 'id'),)


class CdcFields(models.Model):
    id = models.BigAutoField(primary_key=True)
    table_id = models.CharField(max_length=128)
    source_field_name = models.CharField(max_length=128)
    target_field_name = models.CharField(max_length=128, blank=True, null=True)
    field_index = models.DecimalField(
        max_digits=6, decimal_places=0, blank=True, null=True)
    field_type = models.CharField(max_length=40, blank=True, null=True)
    modified_time = models.DateTimeField(blank=True, null=True)
    pk_field = models.DecimalField(
        db_column='pk', max_digits=10, decimal_places=0, blank=True, null=True)
    required = models.DecimalField(
        max_digits=10, decimal_places=0, blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'cdc_fields'
        unique_together = (('table_id', 'source_field_name', 'id'),)
        ordering = ['-id']


class CdcStatus(models.Model):
    id = models.BigAutoField(primary_key=True)
    table_id = models.CharField(max_length=128)
    last_read_seq = models.CharField(max_length=35, blank=True, null=True)
    init_read_seq = models.CharField(max_length=35, blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'cdc_status'
        unique_together = (('table_id', 'id'),)
        ordering = ['-id']

