from rest_framework import serializers
from .models import CdcConn, CdcFields, CdcStatus


class CdcConnSerializer(serializers.ModelSerializer):
    class Meta:
        model = CdcConn
        fields = '__all__'


class CdcFieldsSerializer(serializers.ModelSerializer):
    class Meta:
        model = CdcFields
        fields = '__all__'


class CdcStatusSerializer(serializers.ModelSerializer):
    class Meta:
        model = CdcStatus
        fields = '__all__'
