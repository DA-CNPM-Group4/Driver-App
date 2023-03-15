import 'package:json_annotation/json_annotation.dart';
part 'accept_trip_request.g.dart';

@JsonSerializable()
class AcceptTripRequestParams {
  String? driverId;
  String requestId;

  AcceptTripRequestParams({
    this.driverId,
    required this.requestId,
  });

  factory AcceptTripRequestParams.fromJson(Map<String, dynamic> json) =>
      _$AcceptTripRequestParamsFromJson(json);

  Map<String, dynamic> toJson() => _$AcceptTripRequestParamsToJson(this);
}
