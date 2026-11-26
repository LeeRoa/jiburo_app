import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiburo_app/core/network/api_config.dart';
import 'package:jiburo_app/core/network/api_endpoints.dart';
import 'package:jiburo_app/core/network/token_holder.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

/// 앱 전체 공용 STOMP 연결
/// - CONNECT 시 Authorization 헤더 필수 (서버 StompHandler)
/// - 헤더가 클라이언트 생성 시점에 고정되므로, 재연결 시 최신 토큰으로 클라이언트 재생성
/// - 연결 전 구독 요청은 보관 후 연결(재연결 포함) 시 일괄 구독
class ChatSocketService {
  static const _reconnectDelay = Duration(seconds: 3);

  StompClient? _client;
  bool _connected = false;
  bool _wanted = false; // disconnect() 호출 전까지 true
  Timer? _reconnectTimer;
  final Map<String, void Function()> _subscribers = {};
  final Map<String, Map<String, dynamic>> _queued = {};

  bool get isConnected => _connected;

  static String get _wsUrl =>
      '${apiBaseUrl.replaceFirst(RegExp(r'^http'), 'ws')}${ApiEndpoints.wsEndpoint}';

  void connect() {
    _wanted = true;
    if (_client != null) return;
    final client = StompClient(
      config: StompConfig(
        url: _wsUrl,
        reconnectDelay: Duration.zero, // 자동 재연결 비활성 (_onLost에서 새 토큰으로 재연결)
        stompConnectHeaders: {
          if (TokenHolder.accessToken != null)
            'Authorization': 'Bearer ${TokenHolder.accessToken}',
        },
        onConnect: (_) {
          _connected = true;
          for (final subscribe in _subscribers.values.toList()) {
            subscribe();
          }
          final queued = Map.of(_queued);
          _queued.clear();
          queued.forEach(send);
        },
        onStompError: (_) => _onLost(),
        onWebSocketError: (_) => _onLost(),
        onWebSocketDone: _onLost,
      ),
    );
    _client = client;
    client.activate();
  }

  void _onLost() {
    _connected = false;
    _client?.deactivate();
    _client = null;
    if (!_wanted || _reconnectTimer != null) return;
    _reconnectTimer = Timer(_reconnectDelay, () {
      _reconnectTimer = null;
      if (_wanted) connect();
    });
  }

  /// 구독 등록 (연결 전이면 연결 후 구독), 반환값은 구독 해제 함수
  void Function() subscribe(
    String destination,
    void Function(Map<String, dynamic> body) onMessage,
  ) {
    connect();
    void Function({Map<String, String>? unsubscribeHeaders})? unsub;

    void doSubscribe() {
      unsub = _client?.subscribe(
        destination: destination,
        callback: (frame) {
          final body = frame.body;
          if (body == null) return;
          onMessage(jsonDecode(body) as Map<String, dynamic>);
        },
      );
    }

    final key = '$destination#${identityHashCode(onMessage)}';
    _subscribers[key] = doSubscribe;
    if (_connected) doSubscribe();

    return () {
      _subscribers.remove(key);
      unsub?.call();
    };
  }

  /// 메시지 발행 (연결 전이면 false 반환)
  bool send(String destination, Map<String, dynamic> body) {
    if (!_connected || _client == null) return false;
    _client!.send(destination: destination, body: jsonEncode(body));
    return true;
  }

  /// 지연 발행 허용 메시지 (연결 전이면 destination별 마지막 1건만 보관 후 연결 시 발행)
  void sendWhenConnected(String destination, Map<String, dynamic> body) {
    if (!send(destination, body)) _queued[destination] = body;
  }

  /// 연결 종료 (로그아웃 등 연결 불필요 시점)
  void disconnect() {
    _wanted = false;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _client?.deactivate();
    _client = null;
    _connected = false;
    _subscribers.clear();
    _queued.clear();
  }
}

final chatSocketProvider = Provider<ChatSocketService>((ref) {
  final service = ChatSocketService();
  ref.onDispose(service.disconnect);
  return service;
});
