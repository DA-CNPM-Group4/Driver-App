import 'package:json_annotation/json_annotation.dart';
part 'get_income_request.g.dart';

@JsonSerializable()
class GetIncomeRequestBody {
  String? driverId;
  String from;
  String to;

  GetIncomeRequestBody({
    this.driverId,
    required this.from,
    required this.to,
  });

  factory GetIncomeRequestBody.fromJson(Map<String, dynamic> json) =>
      _$GetIncomeRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$GetIncomeRequestBodyToJson(this);
}
