// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DriverEntityAdapter extends TypeAdapter<DriverEntity> {
  @override
  final int typeId = 0;

  @override
  DriverEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DriverEntity(
      driverId: fields[0] as int?,
      username: fields[10] as String?,
      fullname: fields[1] as String?,
      phone: fields[3] as String?,
      address: fields[2] as String?,
      email: fields[4] as String?,
      gender: fields[7] as String?,
      driverLicenseId: fields[5] as String?,
      driverCitizenId: fields[6] as String?,
      status: fields[8] as String?,
      vehicleList: (fields[9] as List?)?.cast<VehicleListEntity>(),
    );
  }

  @override
  void write(BinaryWriter writer, DriverEntity obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.driverId)
      ..writeByte(10)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.fullname)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.driverLicenseId)
      ..writeByte(6)
      ..write(obj.driverCitizenId)
      ..writeByte(7)
      ..write(obj.gender)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.vehicleList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DriverEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverEntity _$DriverEntityFromJson(Map<String, dynamic> json) => DriverEntity(
      driverId: json['driverId'] as int?,
      username: json['username'] as String?,
      fullname: json['fullname'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      email: json['email'] as String?,
      gender: json['gender'] as String?,
      driverLicenseId: json['driverLicenseId'] as String?,
      driverCitizenId: json['driverCitizenId'] as String?,
      status: json['status'] as String?,
      vehicleList: json['vehicleList'] as List<VehicleListEntity>?,
    );

Map<String, dynamic> _$DriverEntityToJson(DriverEntity instance) =>
    <String, dynamic>{
      'driverId': instance.driverId,
      'username': instance.username,
      'fullname': instance.fullname,
      'address': instance.address,
      'phone': instance.phone,
      'email': instance.email,
      'driverLicenseId': instance.driverLicenseId,
      'driverCitizenId': instance.driverCitizenId,
      'gender': instance.gender,
      'status': instance.status,
      'vehicleList': instance.vehicleList,
    };
