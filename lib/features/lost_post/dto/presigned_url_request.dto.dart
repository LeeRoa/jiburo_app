import 'package:json_annotation/json_annotation.dart';

part 'presigned_url_request.dto.g.dart';

enum FileCode {
  chat('CHAT'),
  chatVideo('CHAT_VIDEO'),
  post('POST'),
  profile('PROFILE'),
  finderImage('FINDER_IMAGE'),
  finderVideo('FINDER_VIDEO');

  final String value;
  const FileCode(this.value);
}

@JsonSerializable()
class PresignedUrlRequest {
  final String fileCode;
  final String originalFileName;
  final String extension;
  final int fileSize;

  PresignedUrlRequest({
    required this.fileCode,
    required this.originalFileName,
    required this.extension,
    required this.fileSize,
  });

  factory PresignedUrlRequest.fromJson(Map<String, dynamic> json) =>
      _$PresignedUrlRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PresignedUrlRequestToJson(this);
}
