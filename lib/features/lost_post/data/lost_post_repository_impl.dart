import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiburo_app/core/dto/api_response.dto.dart';
import 'package:jiburo_app/core/network/api_endpoints.dart';
import 'package:jiburo_app/core/network/dio_client.dart';
import 'package:jiburo_app/features/lost_post/domain/lost_post_repository.dart';
import 'package:jiburo_app/features/lost_post/dto/lost_post_create_request.dto.dart';
import 'package:jiburo_app/features/lost_post/dto/presigned_url_request.dto.dart';
import 'package:jiburo_app/features/lost_post/dto/presigned_url_response.dto.dart';

class LostPostRepositoryImpl implements LostPostRepository {
  final Dio dio;
  LostPostRepositoryImpl(this.dio);

  @override
  Future<void> createPost(LostPostCreateRequest request) async {
    await dio.post(ApiEndpoints.posts, data: request.toJson());
  }

  @override
  Future<String> uploadImage(
    File file, {
    FileCode fileCode = FileCode.post,
  }) async {
    final String fileName = file.path.split(RegExp(r'[/\\]')).last;
    final extension = fileName.split('.').last;
    final fileSize = await file.length();

    final requestDto = PresignedUrlRequest(
      fileCode: fileCode.value,
      originalFileName: fileName,
      extension: extension,
      fileSize: fileSize,
    );

    final response = await dio.post(
      ApiEndpoints.presignedUrl,
      data: requestDto.toJson(),
    );

    final apiResponse = ApiResponseDto<PresignedUrlResponse>.fromJson(
      response.data,
      (json) => PresignedUrlResponse.fromJson(json as Map<String, dynamic>),
    );

    if (!apiResponse.success || apiResponse.data == null) {
      throw Exception(apiResponse.message ?? '이미지 업로드 URL 발급 실패');
    }

    final presignedUrl = apiResponse.data!.presignedUrl;
    final fileKey = apiResponse.data!.fileKey;

    // R2 presigned URL은 앱 인증 헤더(Authorization)가 붙으면 서명 불일치로 거절되므로
    // 인터셉터가 없는 별도 Dio로 업로드한다. Content-Type은 서버가 서명한 값 그대로 보낸다.
    final contentType =
        apiResponse.data!.contentType ?? 'image/${extension.toLowerCase()}';
    await Dio().put(
      presignedUrl,
      data: file.openRead(),
      options: Options(
        headers: {
          Headers.contentTypeHeader: contentType,
          Headers.contentLengthHeader: fileSize,
        },
      ),
    );

    // 업로드 완료 콜백 (ImageMeta PENDING -> COMPLETED). 게시글에는 COMPLETED 키만 첨부 가능
    await dio.post(ApiEndpoints.imageComplete, data: {'fileKey': fileKey});

    return fileKey;
  }
}

final postRepositoryProvider = Provider<LostPostRepository>((ref) {
  return LostPostRepositoryImpl(ref.read(dioProvider));
});
