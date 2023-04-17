import 'package:driver_app/Data/models/requests/trip_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_completed_trip_response.g.dart';

@JsonSerializable()
class GetCompletedTripResponse {
  int total;
  List<TripResponse> trips;

  GetCompletedTripResponse({
    required this.total,
    required this.trips,
  });

  int get totalIncome {
    double sum = 0;
    for (var element in trips) {
      sum += element.price;
    }
    return sum.toInt();
  }

  factory GetCompletedTripResponse.fromJson(Map<String, dynamic> json) =>
      _$GetCompletedTripResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetCompletedTripResponseToJson(this);
}
