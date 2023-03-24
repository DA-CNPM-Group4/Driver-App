// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_list_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VehicleListEntityAdapter extends TypeAdapter<VehicleListEntity> {
  @override
  final int typeId = 1;

  @override
  VehicleListEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VehicleListEntity(
      licensePlateNum: fields[0] as String?,
      driverId: fields[1] as int?,
      ownername: fields[2] as String?,
      typeOfVehicle: fields[3] as String?,
      conditionVehicle: fields[4] as String?,
      brand: fields[5] as String?,
      status: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, VehicleListEntity obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.licensePlateNum)
      ..writeByte(1)
      ..write(obj.driverId)
      ..writeByte(2)
      ..write(obj.ownername)
      ..writeByte(3)
      ..write(obj.typeOfVehicle)
      ..writeByte(4)
      ..write(obj.conditionVehicle)
      ..writeByte(5)
      ..write(obj.brand)
      ..writeByte(6)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VehicleListEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleListEntity _$VehicleListEntityFromJson(Map<String, dynamic> json) =>
    VehicleListEntity(
      licensePlateNum: json['licensePlateNum'] as String?,
      driverId: json['driverId'] as int?,
      ownername: json['ownername'] as String?,
      typeOfVehicle: json['typeOfVehicle'] as String?,
      conditionVehicle: json['conditionVehicle'] as String?,
      brand: json['brand'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$VehicleListEntityToJson(VehicleListEntity instance) =>
    <String, dynamic>{
      'licensePlateNum': instance.licensePlateNum,
      'driverId': instance.driverId,
      'ownername': instance.ownername,
      'typeOfVehicle': instance.typeOfVehicle,
      'conditionVehicle': instance.conditionVehicle,
      'brand': instance.brand,
      'status': instance.status,
    };
