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
      accountId: fields[0] as String,
      identityNumber: fields[1] as String,
      name: fields[4] as String,
      phone: fields[3] as String,
      email: fields[2] as String,
      address: fields[6] as String,
      gender: fields[5] as bool,
      averageRate: fields[7] as double,
      numberOfRate: fields[8] as double,
      numberOfTrip: fields[9] as int,
    )..haveVehicleRegistered = fields[10] as bool?;
  }

  @override
  void write(BinaryWriter writer, DriverEntity obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.accountId)
      ..writeByte(1)
      ..write(obj.identityNumber)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.gender)
      ..writeByte(6)
      ..write(obj.address)
      ..writeByte(7)
      ..write(obj.averageRate)
      ..writeByte(8)
      ..write(obj.numberOfRate)
      ..writeByte(9)
      ..write(obj.numberOfTrip)
      ..writeByte(10)
      ..write(obj.haveVehicleRegistered);
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
      accountId: json['accountId'] as String,
      identityNumber: json['identityNumber'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      address: json['address'] as String,
      gender: json['gender'] as bool,
      averageRate: (json['averageRate'] as num).toDouble(),
      numberOfRate: (json['numberOfRate'] as num).toDouble(),
      numberOfTrip: json['numberOfTrip'] as int,
    )..haveVehicleRegistered = json['haveVehicleRegistered'] as bool?;

Map<String, dynamic> _$DriverEntityToJson(DriverEntity instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'identityNumber': instance.identityNumber,
      'email': instance.email,
      'phone': instance.phone,
      'name': instance.name,
      'gender': instance.gender,
      'address': instance.address,
      'averageRate': instance.averageRate,
      'numberOfRate': instance.numberOfRate,
      'numberOfTrip': instance.numberOfTrip,
      'haveVehicleRegistered': instance.haveVehicleRegistered,
    };
