import 'package:json_annotation/json_annotation.dart';
part 'update_driver_request.g.dart';

@JsonSerializable()
class UpdateDriverRequestBody {
  String IdentityNumber;
  String Email;
  String Phone;
  String Name;
  bool Gender;
  String Address;
  double AverageRate;
  double NumberOfRate;
  int NumberOfTrip;
  String? AccountId;

  UpdateDriverRequestBody(
      {required this.IdentityNumber,
      required this.AverageRate,
      required this.NumberOfTrip,
      required this.NumberOfRate,
      required this.Address,
      required this.Email,
      required this.Phone,
      required this.Gender,
      required this.Name,
      this.AccountId});

  factory UpdateDriverRequestBody.fromJson(Map<String, dynamic> json) =>
      _$UpdateDriverRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateDriverRequestBodyToJson(this);
}
