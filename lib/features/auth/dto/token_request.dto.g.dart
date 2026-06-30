// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_request.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenRequest _$TokenRequestFromJson(Map<String, dynamic> json) => TokenRequest(
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
);

Map<String, dynamic> _$TokenRequestToJson(TokenRequest instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };
