// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accept_trip_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AcceptTripRequestBody _$AcceptTripRequestBodyFromJson(
        Map<String, dynamic> json) =>
    AcceptTripRequestBody(
      driverId: json['driverId'] as String?,
      requestId: json['requestId'] as String,
    );

Map<String, dynamic> _$AcceptTripRequestBodyToJson(
        AcceptTripRequestBody instance) =>
    <String, dynamic>{
      'driverId': instance.driverId,
      'requestId': instance.requestId,
    };
