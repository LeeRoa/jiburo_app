import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiburo_app/core/dto/api_response.dto.dart';
import 'package:jiburo_app/core/network/api_endpoints.dart';
import 'package:jiburo_app/core/network/dio_client.dart';
import 'package:jiburo_app/features/user/dto/user_dtos.dart';

class UserRepository {
  final Dio dio;
  UserRepository(this.dio);

  Future<UserProfile> getMyProfile() async {
    final res = await dio.get(ApiEndpoints.usersMe);
    return UserProfile.fromJson(_data(res.data) as Map<String, dynamic>);
  }

  /// 닉네임 변경 (프로필 사진은 서버가 키→URL 변환을 지원한 뒤 추가)
  Future<UserProfile> updateNickname(String nickname) async {
    final res = await dio.patch(
      ApiEndpoints.usersMe,
      data: {'nickname': nickname},
    );
    return UserProfile.fromJson(_data(res.data) as Map<String, dynamic>);
  }

  Future<MyPostsPage> getMyPosts({int page = 0, int size = 10}) async {
    final res = await dio.get(
      ApiEndpoints.usersMePosts,
      queryParameters: {'page': page, 'size': size},
    );
    return MyPostsPage.fromJson(_data(res.data) as Map<String, dynamic>);
  }

  Future<List<MyActivity>> getMyActivities({int size = 10}) async {
    final res = await dio.get(
      ApiEndpoints.usersMeActivities,
      queryParameters: {'page': 0, 'size': size},
    );
    final data = _data(res.data) as Map<String, dynamic>;
    return (data['content'] as List<dynamic>? ?? [])
        .map((e) => MyActivity.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> withdraw() async {
    final res = await dio.delete(ApiEndpoints.usersMe);
    _data(res.data);
  }

  dynamic _data(dynamic body) {
    final api = ApiResponseDto<Object?>.fromJson(
      body as Map<String, dynamic>,
      (j) => j,
    );
    if (!api.success) {
      throw Exception(api.message ?? '요청에 실패했어요');
    }
    return api.data;
  }
}

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepository(ref.watch(dioProvider)),
);
