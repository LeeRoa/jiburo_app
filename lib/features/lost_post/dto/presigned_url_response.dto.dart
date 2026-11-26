import 'package:json_annotation/json_annotation.dart';

part 'presigned_url_response.dto.g.dart';

@JsonSerializable()
class PresignedUrlResponse {
  final String presignedUrl;
  final String fileKey;
  final String? contentType; // PUT 시 그대로 보내야 하는 Content-Type (서명에 포함)

  PresignedUrlResponse({
    required this.presignedUrl,
    required this.fileKey,
    this.contentType,
  });

  factory PresignedUrlResponse.fromJson(Map<String, dynamic> json) =>
      _$PresignedUrlResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PresignedUrlResponseToJson(this);
}
