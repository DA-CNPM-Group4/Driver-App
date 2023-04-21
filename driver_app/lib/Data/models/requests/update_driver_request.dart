// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
part 'update_driver_request.g.dart';

@JsonSerializable()
class UpdateDriverRequestBody {
  String? AccountId;
  String? Email = "";
  String? Phone = "";
  String Name;
  String IdentityNumber;
  bool Gender;
  String Address;
  double? AverageRate;
  double? NumberOfRate;
  int? NumberOfTrip;

  UpdateDriverRequestBody({
    required this.IdentityNumber,
    required this.Address,
    required this.Gender,
    required this.Name,
    this.Phone,
    this.Email,
  });

  factory UpdateDriverRequestBody.fromJson(Map<String, dynamic> json) =>
      _$UpdateDriverRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateDriverRequestBodyToJson(this);
}
