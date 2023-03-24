// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_driver_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginDriverRequestBody _$LoginDriverRequestBodyFromJson(
        Map<String, dynamic> json) =>
    LoginDriverRequestBody(
      email: json['email'] as String,
      phone: json['phone'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$LoginDriverRequestBodyToJson(
        LoginDriverRequestBody instance) =>
    <String, dynamic>{
      'email': instance.email,
      'phone': instance.phone,
      'password': instance.password,
    };
