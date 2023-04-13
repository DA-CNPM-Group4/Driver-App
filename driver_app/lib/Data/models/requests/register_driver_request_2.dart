import 'package:json_annotation/json_annotation.dart';

part 'register_driver_request_2.g.dart';

@JsonSerializable()
class RegisterDriverRequestBodyV2 {
  String email;
  String phone;
  String password;
  String? role = "Driver";
  String name;

  bool gender;
  String identityNumber;
  String address;
  String mode = "2";

  RegisterDriverRequestBodyV2({
    required this.email,
    required this.phone,
    required this.password,
    required this.name,
    required this.gender,
    required this.identityNumber,
    required this.address,
  });

  factory RegisterDriverRequestBodyV2.fromJson(Map<String, dynamic> json) =>
      _$RegisterDriverRequestBodyV2FromJson(json);

  Map<String, dynamic> toJson() => _$RegisterDriverRequestBodyV2ToJson(this);
}
