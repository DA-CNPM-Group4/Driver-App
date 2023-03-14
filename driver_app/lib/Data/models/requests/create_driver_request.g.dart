// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_driver_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateDriverRequestBody _$CreateDriverRequestBodyFromJson(
        Map<String, dynamic> json) =>
    CreateDriverRequestBody(
      IdentityNumber: json['IdentityNumber'] as String,
      AverageRate: (json['AverageRate'] as num).toDouble(),
      NumberOfTrip: json['NumberOfTrip'] as int,
      NumberOfRate: (json['NumberOfRate'] as num).toDouble(),
      Address: json['Address'] as String,
      Email: json['Email'] as String,
      Phone: json['Phone'] as String,
      Gender: json['Gender'] as bool,
      Name: json['Name'] as String,
      AccountId: json['AccountId'] as String?,
    );

Map<String, dynamic> _$CreateDriverRequestBodyToJson(
        CreateDriverRequestBody instance) =>
    <String, dynamic>{
      'IdentityNumber': instance.IdentityNumber,
      'Email': instance.Email,
      'Phone': instance.Phone,
      'Name': instance.Name,
      'Gender': instance.Gender,
      'Address': instance.Address,
      'AverageRate': instance.AverageRate,
      'NumberOfRate': instance.NumberOfRate,
      'NumberOfTrip': instance.NumberOfTrip,
      'AccountId': instance.AccountId,
    };
