// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_completed_trip_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetCompletedTripResponse _$GetCompletedTripResponseFromJson(
        Map<String, dynamic> json) =>
    GetCompletedTripResponse(
      total: json['total'] as int,
      trips: (json['trips'] as List<dynamic>)
          .map((e) => TripResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetCompletedTripResponseToJson(
        GetCompletedTripResponse instance) =>
    <String, dynamic>{
      'total': instance.total,
      'trips': instance.trips,
    };
