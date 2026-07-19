// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presigned_url_request.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PresignedUrlRequest _$PresignedUrlRequestFromJson(Map<String, dynamic> json) =>
    PresignedUrlRequest(
      fileCode: json['fileCode'] as String,
      originalFileName: json['originalFileName'] as String,
      extension: json['extension'] as String,
      fileSize: (json['fileSize'] as num).toInt(),
    );

Map<String, dynamic> _$PresignedUrlRequestToJson(
  PresignedUrlRequest instance,
) => <String, dynamic>{
  'fileCode': instance.fileCode,
  'originalFileName': instance.originalFileName,
  'extension': instance.extension,
  'fileSize': instance.fileSize,
};
