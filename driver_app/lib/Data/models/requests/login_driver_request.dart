import 'package:json_annotation/json_annotation.dart';
part 'login_driver_request.g.dart';

@JsonSerializable()
class LoginDriverRequestBody {
  String email;
  String phone;
  String password;
  String? role = "Driver";

  LoginDriverRequestBody({
    required this.email,
    required this.phone,
    required this.password,
  });

  factory LoginDriverRequestBody.fromJson(Map<String, dynamic> json) =>
      _$LoginDriverRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$LoginDriverRequestBodyToJson(this);
}
