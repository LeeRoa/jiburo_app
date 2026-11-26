import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiburo_app/core/network/api_endpoints.dart';
import 'package:jiburo_app/core/network/token_holder.dart';
import 'package:jiburo_app/features/auth/providers/auth_provider.dart';
import 'package:jiburo_app/features/chat/data/chat_repository.dart';
import 'package:jiburo_app/features/chat/data/chat_socket_service.dart';
import 'package:jiburo_app/features/chat/dto/chat_dtos.dart';
import 'package:jiburo_app/features/lost_post/dto/post_summary.dart';
import 'package:jiburo_app/features/lost_post/dto/presigned_url_request.dto.dart';
import 'package:jiburo_app/features/lost_post/data/lost_post_repository_impl.dart';

/// 내 사용자 ID (액세스 토큰 JWT의 sub), 내 메시지 구분용
final myUserIdProvider = Provider<String?>((ref) {
  ref.watch(authProvider); // 로그인·로그아웃·토큰 재발급 시 재계산
  final token = TokenHolder.accessToken;
  if (token == null) return null;
  try {
    final payload = token.split('.')[1];
    final json = utf8.decode(base64Url.decode(base64Url.normalize(payload)));
    return (jsonDecode(json) as Map<String, dynamic>)['sub'] as String?;
  } catch (_) {
    return null;
  }
});

/// 내 채팅방 목록 (새로고침은 invalidate)
final chatRoomsProvider = FutureProvider.autoDispose<List<ChatRoom>>((ref) {
  ref.watch(authProvider);
  if (TokenHolder.accessToken == null) return const <ChatRoom>[];
  return ref.watch(chatRepositoryProvider).fetchRooms();
});

/// 채팅방 상단 게시글 카드 데이터
final chatPostProvider = FutureProvider.autoDispose.family<PostSummary, String>(
  (ref, postId) => ref.watch(chatRepositoryProvider).fetchPostSummary(postId),
);

class ChatRoomState {
  final ChatRoomDetail detail;
  final List<ChatMessage> messages; // 오래된 순
  const ChatRoomState({required this.detail, required this.messages});

  ChatRoomState copyWith({List<ChatMessage>? messages}) =>
      ChatRoomState(detail: detail, messages: messages ?? this.messages);
}

/// 채팅방 단위 상태 (내역 조회, 실시간 수신, 전송, 읽음 처리)
class ChatRoomNotifier
    extends AutoDisposeFamilyAsyncNotifier<ChatRoomState, String> {
  void Function()? _unsubMessages;
  void Function()? _unsubRead;

  @override
  Future<ChatRoomState> build(String roomId) async {
    final repo = ref.read(chatRepositoryProvider);
    final socket = ref.read(chatSocketProvider);

    // 오래된 순 50개 페이지 구조, 최신 메시지까지 hasNext 종료 시점까지 순차 조회
    var detail = await repo.fetchRoomDetail(roomId);
    final all = [...detail.messages];
    for (var page = 1; detail.hasNext && page < 40; page++) {
      detail = await repo.fetchRoomDetail(roomId, page: page);
      all.addAll(detail.messages);
    }

    _unsubMessages = socket.subscribe(ApiEndpoints.subRoom(roomId), (json) {
      _onMessage(ChatMessage.fromJson(json));
    });
    _unsubRead = socket.subscribe(ApiEndpoints.subRoomRead(roomId), (json) {
      _onRead(ChatReadEvent.fromJson(json));
    });
    ref.onDispose(() {
      _unsubMessages?.call();
      _unsubRead?.call();
    });

    final result = ChatRoomState(detail: detail, messages: all);
    _markReadLater(all);
    return result;
  }

  String? get _myId => ref.read(myUserIdProvider);

  void _onMessage(ChatMessage message) {
    final current = state.valueOrNull;
    if (current == null) return;
    if (current.messages.any((m) => m.messageId == message.messageId)) return;
    final updated = [...current.messages, message];
    state = AsyncData(current.copyWith(messages: updated));
    if (message.senderId != _myId) _markReadLater(updated);
  }

  /// 상대 읽음 이벤트 반영 (해당 메시지 이하 내 메시지의 안읽음 표시 제거)
  void _onRead(ChatReadEvent event) {
    final current = state.valueOrNull;
    if (current == null || event.userId == _myId) return;
    final idx = current.messages.indexWhere(
      (m) => m.messageId == event.lastReadMessageId,
    );
    if (idx < 0) return;
    final updated = [
      for (var i = 0; i < current.messages.length; i++)
        if (i <= idx && current.messages[i].senderId == _myId)
          current.messages[i].copyWith(unreadCount: 0)
        else
          current.messages[i],
    ];
    state = AsyncData(current.copyWith(messages: updated));
  }

  /// 상대 마지막 메시지 기준 읽음 신호 발행
  void _markReadLater(List<ChatMessage> messages) {
    final myId = _myId;
    for (var i = messages.length - 1; i >= 0; i--) {
      if (messages[i].senderId == myId) continue;
      // 연결 전이면 큐 보관 후 연결 시 발행
      ref.read(chatSocketProvider).sendWhenConnected(
        ApiEndpoints.pubRoomRead(arg),
        {'lastReadMessageId': messages[i].messageId},
      );
      return;
    }
  }

  /// 텍스트 전송 (화면 반영은 서버 저장 후 구독으로 수신한 메시지 기준)
  /// 소켓 연결 전이면 false 반환
  bool sendText(String text) {
    final content = text.trim();
    if (content.isEmpty) return false;
    return ref.read(chatSocketProvider).send(ApiEndpoints.pubRoom(arg), {
      'content': content,
      'messageTypeCode': 'TALK',
    });
  }

  Future<bool> sendImage(File file) async {
    final key = await ref
        .read(postRepositoryProvider)
        .uploadImage(file, fileCode: FileCode.chat);
    return ref.read(chatSocketProvider).send(ApiEndpoints.pubRoom(arg), {
      'content': key,
      'messageTypeCode': 'IMAGE',
    });
  }
}

final chatRoomProvider = AsyncNotifierProvider.autoDispose
    .family<ChatRoomNotifier, ChatRoomState, String>(ChatRoomNotifier.new);
