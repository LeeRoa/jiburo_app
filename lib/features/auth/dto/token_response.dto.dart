import 'package:json_annotation/json_annotation.dart';

part 'token_response.dto.g.dart';

@JsonSerializable()
class TokenResponse {
  final String grantType;
  final String accessToken;
  final String refreshToken;
  final int accessTokenExpireIn;

  TokenResponse({
    required this.grantType,
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpireIn,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TokenResponseToJson(this);
}
