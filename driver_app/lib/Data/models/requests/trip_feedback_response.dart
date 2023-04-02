import 'package:json_annotation/json_annotation.dart';

part 'trip_feedback_response.g.dart';

@JsonSerializable()
class TripFeedbackResponse {
  String tripId;
  String note;
  double rate;

  TripFeedbackResponse({
    required this.tripId,
    required this.note,
    required this.rate,
  });

  factory TripFeedbackResponse.fromJson(Map<String, dynamic> json) =>
      _$TripFeedbackResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TripFeedbackResponseToJson(this);
}
