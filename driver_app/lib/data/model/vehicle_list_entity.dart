import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vehicle_list_entity.g.dart';
@HiveType(typeId: 1)
@JsonSerializable()
class VehicleListEntity extends HiveObject{
  @HiveField(0)
  String? licensePlateNum;
  @HiveField(1)
  int? driverId;
  @HiveField(2)
  String? ownername;
  @HiveField(3)
  String? typeOfVehicle;
  @HiveField(4)
  String? conditionVehicle;
  @HiveField(5)
  String? brand;
  @HiveField(6)
  String? status;

  VehicleListEntity(
      {required this.licensePlateNum,
        required this.driverId,
        required this.ownername,
        required this.typeOfVehicle,
        required this.conditionVehicle,
       required this.brand,
       required this.status});

  factory VehicleListEntity.fromJson(Map<String, dynamic> json) => _$VehicleListEntityFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleListEntityToJson(this);
}
