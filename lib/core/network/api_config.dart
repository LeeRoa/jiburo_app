/// 서버 주소. 실행할 때 바꿀 수 있다:
///   flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080   (안드로이드 에뮬레이터)
///   flutter run --dart-define=API_BASE_URL=http://192.168.0.10:8080 (실제 기기, PC의 LAN IP)
const String apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:8080',
);

/// 카카오 네이티브 앱 키 (카카오 디벨로퍼스 > 앱 키 > 네이티브 앱 키).
/// 지도 SDK 초기화에 쓰는 키와 같은 앱의 키이며, Android/iOS 설정의 `kakao{키}` 스킴과 일치해야 한다.
const String kakaoNativeAppKey = String.fromEnvironment(
  'KAKAO_NATIVE_APP_KEY',
  defaultValue: '54b8d7c26f777cbf09b20c3760b731d5',
);
