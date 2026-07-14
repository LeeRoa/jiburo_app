import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiburo_app/core/network/api_endpoints.dart';
import 'package:jiburo_app/core/network/dio_client.dart';
import 'package:jiburo_app/features/lost_post/domain/lost_post_repository.dart';
import 'package:jiburo_app/features/lost_post/dto/lost_post_create_request.dto.dart';

class LostPostRepositoryImpl implements LostPostRepository {
  final Dio dio;
  LostPostRepositoryImpl(this.dio);

  @override
  Future<void> createPost(LostPostCreateRequest request) async {
    await dio.post(ApiEndpoints.posts, data: request.toJson());
  }
}

final postRepositoryProvider = Provider<LostPostRepository>((ref) {
  return LostPostRepositoryImpl(ref.read(dioProvider));
});
