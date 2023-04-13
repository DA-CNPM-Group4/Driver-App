// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_driver_request_2.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterDriverRequestBodyV2 _$RegisterDriverRequestBodyV2FromJson(
        Map<String, dynamic> json) =>
    RegisterDriverRequestBodyV2(
      email: json['email'] as String,
      phone: json['phone'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
      gender: json['gender'] as bool,
      identityNumber: json['identityNumber'] as String,
      address: json['address'] as String,
    )
      ..role = json['role'] as String?
      ..mode = json['mode'] as String;

Map<String, dynamic> _$RegisterDriverRequestBodyV2ToJson(
        RegisterDriverRequestBodyV2 instance) =>
    <String, dynamic>{
      'email': instance.email,
      'phone': instance.phone,
      'password': instance.password,
      'role': instance.role,
      'name': instance.name,
      'gender': instance.gender,
      'identityNumber': instance.identityNumber,
      'address': instance.address,
      'mode': instance.mode,
    };
