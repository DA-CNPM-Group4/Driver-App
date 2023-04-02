// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_feedback_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TripFeedbackResponse _$TripFeedbackResponseFromJson(
        Map<String, dynamic> json) =>
    TripFeedbackResponse(
      tripId: json['tripId'] as String,
      note: json['note'] as String,
      rate: (json['rate'] as num).toDouble(),
    );

Map<String, dynamic> _$TripFeedbackResponseToJson(
        TripFeedbackResponse instance) =>
    <String, dynamic>{
      'tripId': instance.tripId,
      'note': instance.note,
      'rate': instance.rate,
    };
