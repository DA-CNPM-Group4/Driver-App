// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
part 'create_vehicle_request.g.dart';

@JsonSerializable()
class CreateVehicleRequestBody {
  String? VehicleId;
  String? DriverId;
  String VehicleType;
  String VehicleName;
  String Brand;
  String LicensePlatesNum;

  CreateVehicleRequestBody({
    this.VehicleId,
    this.DriverId,
    required this.VehicleType,
    required this.Brand,
    required this.VehicleName,
    required this.LicensePlatesNum,
  });

  factory CreateVehicleRequestBody.fromJson(Map<String, dynamic> json) =>
      _$CreateVehicleRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$CreateVehicleRequestBodyToJson(this);
}
