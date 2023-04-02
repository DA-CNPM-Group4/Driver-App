import 'package:json_annotation/json_annotation.dart';
part 'accept_trip_request.g.dart';

@JsonSerializable()
class AcceptTripRequestBody {
  String? driverId;
  String requestId;

  AcceptTripRequestBody({
    this.driverId,
    required this.requestId,
  });

  factory AcceptTripRequestBody.fromJson(Map<String, dynamic> json) =>
      _$AcceptTripRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$AcceptTripRequestBodyToJson(this);
}
