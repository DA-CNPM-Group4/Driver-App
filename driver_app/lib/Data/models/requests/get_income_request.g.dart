// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_income_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetIncomeRequestBody _$GetIncomeRequestBodyFromJson(
        Map<String, dynamic> json) =>
    GetIncomeRequestBody(
      driverId: json['driverId'] as String?,
      from: json['from'] as String,
      to: json['to'] as String,
    );

Map<String, dynamic> _$GetIncomeRequestBodyToJson(
        GetIncomeRequestBody instance) =>
    <String, dynamic>{
      'driverId': instance.driverId,
      'from': instance.from,
      'to': instance.to,
    };
