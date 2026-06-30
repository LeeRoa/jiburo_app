// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_code_response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommonCodeResponse _$CommonCodeResponseFromJson(Map<String, dynamic> json) =>
    CommonCodeResponse(
      code: json['code'] as String,
      ref1: json['ref1'] as String?,
      ref2: json['ref2'] as String?,
    );

Map<String, dynamic> _$CommonCodeResponseToJson(CommonCodeResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'ref1': instance.ref1,
      'ref2': instance.ref2,
    };
