// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presigned_url_response.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PresignedUrlResponse _$PresignedUrlResponseFromJson(
  Map<String, dynamic> json,
) => PresignedUrlResponse(
  presignedUrl: json['presignedUrl'] as String,
  fileKey: json['fileKey'] as String,
);

Map<String, dynamic> _$PresignedUrlResponseToJson(
  PresignedUrlResponse instance,
) => <String, dynamic>{
  'presignedUrl': instance.presignedUrl,
  'fileKey': instance.fileKey,
};
