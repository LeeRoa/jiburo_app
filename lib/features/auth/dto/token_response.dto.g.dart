// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenResponse _$TokenResponseFromJson(Map<String, dynamic> json) =>
    TokenResponse(
      grantType: json['grantType'] as String,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      accessTokenExpireIn: (json['accessTokenExpireIn'] as num).toInt(),
    );

Map<String, dynamic> _$TokenResponseToJson(TokenResponse instance) =>
    <String, dynamic>{
      'grantType': instance.grantType,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'accessTokenExpireIn': instance.accessTokenExpireIn,
    };
