// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_driver_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterDriverRequestBody _$RegisterDriverRequestBodyFromJson(
        Map<String, dynamic> json) =>
    RegisterDriverRequestBody(
      email: json['email'] as String,
      phone: json['phone'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
    )..role = json['role'] as String?;

Map<String, dynamic> _$RegisterDriverRequestBodyToJson(
        RegisterDriverRequestBody instance) =>
    <String, dynamic>{
      'email': instance.email,
      'phone': instance.phone,
      'password': instance.password,
      'role': instance.role,
      'name': instance.name,
    };
