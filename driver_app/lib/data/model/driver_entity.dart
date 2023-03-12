import 'package:driver_app/data/model/vehicle_list_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'driver_entity.g.dart';
@HiveType(typeId: 0)
@JsonSerializable()
class DriverEntity extends HiveObject{
  @HiveField(0)
  int? driverId;

  @HiveField(10)
  String? username;



  @HiveField(1)
  String? fullname;

  @HiveField(2)
  String? address;

  @HiveField(3)
  String? phone;

  @HiveField(4)
  String? email;

  @HiveField(5)
  String? driverLicenseId;

  @HiveField(6)
  String? driverCitizenId;

  @HiveField(7)
  String? gender;

  @HiveField(8)
  String? status;

  @HiveField(9)
  List<VehicleListEntity>? vehicleList;

  DriverEntity(
      {required this.driverId,
        required this.username,
        required this.fullname,
        required this.phone,
        required this.address,
        required this.email,
        required this.gender,
        required this.driverLicenseId,
        required this.driverCitizenId,
        required this.status,
        required this.vehicleList});


  factory DriverEntity.fromJson(Map<String, dynamic> json) => _$DriverEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DriverEntityToJson(this);
}

