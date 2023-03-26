import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vehicle_entity.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class VehicleEntity extends HiveObject {
  @HiveField(0)
  String vehicleId;
  @HiveField(1)
  String driverId;
  @HiveField(2)
  String vehicleType;
  @HiveField(3)
  String vehicleName;
  @HiveField(4)
  String brand;
  @HiveField(5)
  String licensePlatesNum;

  VehicleEntity({
    required this.vehicleId,
    required this.driverId,
    required this.vehicleType,
    required this.vehicleName,
    required this.brand,
    required this.licensePlatesNum,
  });

  factory VehicleEntity.fromJson(Map<String, dynamic> json) =>
      _$VehicleEntityFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleEntityToJson(this);
}
