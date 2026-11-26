import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiburo_app/core/dto/api_response.dto.dart';
import 'package:jiburo_app/core/network/api_endpoints.dart';
import 'package:jiburo_app/core/network/dio_client.dart';
import 'package:jiburo_app/features/chat/dto/chat_dtos.dart';
import 'package:jiburo_app/features/lost_post/dto/post_summary.dart';

class ChatRepository {
  final Dio dio;
  ChatRepository(this.dio);

  /// 게시글 기반 채팅방 생성 (기존 방 존재 시 해당 방 반환)
  Future<ChatRoom> createRoom(String postId) async {
    final res = await dio.post(ApiEndpoints.rooms, data: {'postId': postId});
    return ChatRoom.fromJson(_data(res.data) as Map<String, dynamic>);
  }

  Future<List<ChatRoom>> fetchRooms() async {
    final res = await dio.get(ApiEndpoints.rooms);
    return (_data(res.data) as List<dynamic>)
        .map((e) => ChatRoom.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ChatRoomDetail> fetchRoomDetail(String roomId, {int page = 0}) async {
    final res = await dio.get(
      ApiEndpoints.roomsMessage(roomId),
      queryParameters: {'page': page, 'size': 50},
    );
    return ChatRoomDetail.fromJson(_data(res.data) as Map<String, dynamic>);
  }

  Future<PostSummary> fetchPostSummary(String postId) async {
    final res = await dio.get(ApiEndpoints.postById(postId));
    return PostSummary.fromJson(_data(res.data) as Map<String, dynamic>);
  }

  Future<void> exitRoom(String roomId) async {
    final res = await dio.delete(ApiEndpoints.room(roomId));
    _data(res.data);
  }

  dynamic _data(dynamic body) {
    final api = ApiResponseDto<Object?>.fromJson(
      body as Map<String, dynamic>,
      (j) => j,
    );
    if (!api.success) {
      throw ChatException(api.errorCode, api.message ?? '요청에 실패했어요');
    }
    return api.data;
  }
}

class ChatException implements Exception {
  final String? code;
  final String message;
  ChatException(this.code, this.message);
  @override
  String toString() => message;
}

final chatRepositoryProvider = Provider<ChatRepository>(
  (ref) => ChatRepository(ref.watch(dioProvider)),
);
