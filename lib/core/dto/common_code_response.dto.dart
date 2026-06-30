import 'package:json_annotation/json_annotation.dart';

part 'common_code_response.dto.g.dart';

@JsonSerializable()
class CommonCodeResponse {
  final String code;
  final String? ref1;
  final String? ref2;

  CommonCodeResponse({required this.code, this.ref1, this.ref2});

  factory CommonCodeResponse.fromJson(Map<String, dynamic> json) =>
      _$CommonCodeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CommonCodeResponseToJson(this);
}
