import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationNotifier extends Notifier<bool> {
  @override
  bool build() => false; // 초기값

  // 외부연결
  void setNew(bool value) => state = value;
}

final notificationProvider = NotifierProvider<NotificationNotifier, bool>(
  NotificationNotifier.new,
);

// 추후 api 붙일 때 StreamProvider로 웹소켓 연결 (실시간 처리) 아니면 Future
// final notificationStreamProvider = StreamProvider<bool>((ref) {
//   // 웹소켓 연결해서 알림 스트림 반환
//   return webSocketService.notificationStream();
// });
