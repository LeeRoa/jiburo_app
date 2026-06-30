import 'package:json_annotation/json_annotation.dart';

part 'token_request.dto.g.dart';

@JsonSerializable()
class TokenRequest {
  final String accessToken;
  final String refreshToken;

  TokenRequest({required this.accessToken, required this.refreshToken});

  factory TokenRequest.fromJson(Map<String, dynamic> json) =>
      _$TokenRequestFromJson(json);
  Map<String, dynamic> toJson() => _$TokenRequestToJson(this);
}
