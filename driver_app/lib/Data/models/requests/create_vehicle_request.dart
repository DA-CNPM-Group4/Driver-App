import 'package:json_annotation/json_annotation.dart';
part 'create_vehicle_request.g.dart';

@JsonSerializable()
class CreateVehicleRequestBody {
  String? VehicleId;
  String? DriverId;
  String VehicleType;
  String VehicleName;
  String Brand;

  CreateVehicleRequestBody({
    this.VehicleId,
    this.DriverId,
    required this.VehicleType,
    required this.Brand,
    required this.VehicleName,
  });

  factory CreateVehicleRequestBody.fromJson(Map<String, dynamic> json) =>
      _$CreateVehicleRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$CreateVehicleRequestBodyToJson(this);
}
