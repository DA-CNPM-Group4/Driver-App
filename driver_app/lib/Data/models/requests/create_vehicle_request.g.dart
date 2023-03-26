// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_vehicle_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateVehicleRequestBody _$CreateVehicleRequestBodyFromJson(
        Map<String, dynamic> json) =>
    CreateVehicleRequestBody(
      VehicleId: json['VehicleId'] as String?,
      DriverId: json['DriverId'] as String?,
      VehicleType: json['VehicleType'] as String,
      Brand: json['Brand'] as String,
      VehicleName: json['VehicleName'] as String,
      LicensePlatesNum: json['LicensePlatesNum'] as String,
    );

Map<String, dynamic> _$CreateVehicleRequestBodyToJson(
        CreateVehicleRequestBody instance) =>
    <String, dynamic>{
      'VehicleId': instance.VehicleId,
      'DriverId': instance.DriverId,
      'VehicleType': instance.VehicleType,
      'VehicleName': instance.VehicleName,
      'Brand': instance.Brand,
      'LicensePlatesNum': instance.LicensePlatesNum,
    };
