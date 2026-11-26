/// 서버 주소. 실행할 때 바꿀 수 있다:
///   flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080   (안드로이드 에뮬레이터)
///   flutter run --dart-define=API_BASE_URL=http://192.168.0.10:8080 (실제 기기, PC의 LAN IP)
const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:8080',
);
