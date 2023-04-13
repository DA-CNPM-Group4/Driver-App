import 'package:json_annotation/json_annotation.dart';
part 'register_driver_request.g.dart';

@JsonSerializable()
class RegisterDriverRequestBody {
  String email;
  String phone;
  String password;
  String? role = "Driver";
  String name;
  String mode = "1";

  RegisterDriverRequestBody({
    required this.email,
    required this.phone,
    required this.password,
    required this.name,
  });

  factory RegisterDriverRequestBody.fromJson(Map<String, dynamic> json) =>
      _$RegisterDriverRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterDriverRequestBodyToJson(this);
}
