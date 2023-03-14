import 'package:json_annotation/json_annotation.dart';
part 'create_driver_request.g.dart';

@JsonSerializable()
class CreateDriverRequestBody {
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

  CreateDriverRequestBody(
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

  factory CreateDriverRequestBody.fromJson(Map<String, dynamic> json) =>
      _$CreateDriverRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$CreateDriverRequestBodyToJson(this);
}
