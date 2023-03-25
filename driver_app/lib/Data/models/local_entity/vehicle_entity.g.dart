// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VehicleEntityAdapter extends TypeAdapter<VehicleEntity> {
  @override
  final int typeId = 1;

  @override
  VehicleEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VehicleEntity(
      vehicleId: fields[0] as String?,
      driverId: fields[1] as int?,
      vehicleType: fields[2] as String?,
      vehicleName: fields[3] as String?,
      brand: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, VehicleEntity obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.vehicleId)
      ..writeByte(1)
      ..write(obj.driverId)
      ..writeByte(2)
      ..write(obj.vehicleType)
      ..writeByte(3)
      ..write(obj.vehicleName)
      ..writeByte(4)
      ..write(obj.brand);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VehicleEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleEntity _$VehicleEntityFromJson(Map<String, dynamic> json) =>
    VehicleEntity(
      vehicleId: json['vehicleId'] as String?,
      driverId: json['driverId'] as int?,
      vehicleType: json['vehicleType'] as String?,
      vehicleName: json['vehicleName'] as String?,
      brand: json['brand'] as String?,
    );

Map<String, dynamic> _$VehicleEntityToJson(VehicleEntity instance) =>
    <String, dynamic>{
      'vehicleId': instance.vehicleId,
      'driverId': instance.driverId,
      'vehicleType': instance.vehicleType,
      'vehicleName': instance.vehicleName,
      'brand': instance.brand,
    };
