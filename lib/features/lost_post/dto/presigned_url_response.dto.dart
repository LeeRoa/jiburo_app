import 'package:json_annotation/json_annotation.dart';

part 'presigned_url_response.dto.g.dart';

@JsonSerializable()
class PresignedUrlResponse {
  final String presignedUrl;
  final String fileKey;

  PresignedUrlResponse({required this.presignedUrl, required this.fileKey});

  factory PresignedUrlResponse.fromJson(Map<String, dynamic> json) =>
      _$PresignedUrlResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PresignedUrlResponseToJson(this);
}
