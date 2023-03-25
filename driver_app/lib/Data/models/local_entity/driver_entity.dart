import 'package:driver_app/Data/models/local_entity/vehicle_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'driver_entity.g.dart';

@HiveType(typeId: 0)
@JsonSerializable(explicitToJson: true)
class DriverEntity extends HiveObject {
  @HiveField(0)
  String? accountId;

  @HiveField(1)
  String? identityNumber;

  @HiveField(2)
  String? email;

  @HiveField(3)
  String? phone;

  @HiveField(4)
  String? name;

  @HiveField(5)
  bool? gender;

  @HiveField(6)
  String? address;

  @HiveField(7)
  double averageRate;

  @HiveField(8)
  double numberOfRate;

  @HiveField(10)
  int numberOfTrip;

  @HiveField(9)
  List<VehicleEntity>? vehicleList;

  DriverEntity({
    required this.accountId,
    required this.identityNumber,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.gender,
    required this.averageRate,
    required this.numberOfRate,
    required this.numberOfTrip,
  });

  factory DriverEntity.fromJson(Map<String, dynamic> json) =>
      _$DriverEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DriverEntityToJson(this);
}
