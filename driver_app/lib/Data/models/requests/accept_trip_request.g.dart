// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accept_trip_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AcceptTripRequestParams _$AcceptTripRequestParamsFromJson(
        Map<String, dynamic> json) =>
    AcceptTripRequestParams(
      driverId: json['driverId'] as String?,
      requestId: json['requestId'] as String,
    );

Map<String, dynamic> _$AcceptTripRequestParamsToJson(
        AcceptTripRequestParams instance) =>
    <String, dynamic>{
      'driverId': instance.driverId,
      'requestId': instance.requestId,
    };
