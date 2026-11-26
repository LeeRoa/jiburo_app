import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:jiburo_app/core/network/api_config.dart';
import 'package:jiburo_app/core/network/api_endpoints.dart';
import 'package:jiburo_app/core/network/dio_client.dart';
import 'package:jiburo_app/core/network/token_holder.dart';
import 'package:jiburo_app/core/storage/secure_storage_service.dart';
import 'package:jiburo_app/features/auth/domain/auth_repository.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio dio;
  final SecureStorageService secureStorageService;

  AuthRepositoryImpl(this.secureStorageService, this.dio);

  @override
  Future<void> signIn(String type) async {
    if (type == 'kakao') {
      await _kakaoSignIn();
      return;
    }

    final result = await FlutterWebAuth2.authenticate(
      url: '$apiBaseUrl/oauth2/authorization/$type',
      callbackUrlScheme: 'jiburo',
      // options: FlutterWebAuth2Options(preferEphemeral: true),
    );

    // 서버는 토큰 대신 1회용 code만 리다이렉트로 전달 (토큰은 POST /auth/token 교환)
    final uri = Uri.parse(result);
    final error = uri.queryParameters['error'];
    if (error != null) {
      throw Exception('로그인 실패: $error');
    }

    final code = uri.queryParameters['code'];
    if (code == null) {
      throw Exception('로그인 실패: code 없음');
    }

    final response = await dio.post(
      ApiEndpoints.authToken,
      data: {'code': code},
    );
    await _saveTokens(_unwrap(response.data));
  }

  // 카카오 SDK 로그인: 카카오톡(없으면 카카오 계정)으로 로그인해 받은 카카오 액세스 토큰을
  // 서버(POST /auth/login/kakao)에 보내 우리 서비스의 Access/Refresh Token으로 교환한다.
  Future<void> _kakaoSignIn() async {
    if (kIsWeb) {
      throw Exception('카카오 로그인은 Android/iOS 앱에서만 지원해요');
    }

    OAuthToken kakaoToken;
    if (await isKakaoTalkInstalled()) {
      try {
        kakaoToken = await UserApi.instance.loginWithKakaoTalk();
      } catch (e) {
        // 카카오톡 로그인을 사용자가 취소한 경우에는 계정 로그인으로 넘어가지 않고 중단
        if (e is PlatformException && e.code == 'CANCELED') rethrow;
        kakaoToken = await UserApi.instance.loginWithKakaoAccount();
      }
    } else {
      kakaoToken = await UserApi.instance.loginWithKakaoAccount();
    }

    final response = await dio.post(
      '/api/v1/auth/login/kakao',
      data: {'accessToken': kakaoToken.accessToken},
    );
    await _saveTokens(_unwrap(response.data));
  }

  Future<void> _saveTokens(Map<String, dynamic> data) async {
    final accessToken = data['accessToken'] as String?;
    final refreshToken = data['refreshToken'] as String?;

    if (accessToken == null) {
      throw Exception('로그인 실패: accessToken 없음');
    }

    TokenHolder.accessToken = accessToken;
    if (refreshToken != null) {
      await secureStorageService.saveRefreshToken(refreshToken);
    }
  }

  @override
  Future<void> devSignIn(String nickname) async {
    // 서버 local 프로파일에서만 열리는 /auth/dev-login. 소셜 로그인 없이 테스트 계정으로 토큰을 받는다.
    final response = await dio.post(
      '/api/v1/auth/dev-login',
      data: {'nickname': nickname},
    );

    final data = _unwrap(response.data);
    final accessToken = data['accessToken'] as String?;
    final refreshToken = data['refreshToken'] as String?;

    if (accessToken == null) {
      throw Exception('개발 로그인 실패: accessToken 없음');
    }

    TokenHolder.accessToken = accessToken;
    if (refreshToken != null) {
      await secureStorageService.saveRefreshToken(refreshToken);
    }
  }

  // 서버 응답은 ApiResponse({success, data}) 래퍼로 내려온다. 래퍼가 없으면 그대로 사용.
  Map<String, dynamic> _unwrap(dynamic body) {
    final map = body as Map<String, dynamic>;
    final inner = map['data'];
    return inner is Map<String, dynamic> ? inner : map;
  }

  @override
  Future<void> logout() async {
    await dio.post(ApiEndpoints.authLogout);
  }

  @override
  Future<String> reissue() async {
    final refreshToken = await secureStorageService.getRefreshToken();

    if (refreshToken == null) {
      throw Exception('No Refresh Token');
    }

    // 주입받은 this.dio를 쓰지 않고, 무한 재귀 에러를 막기 위해
    // 아무런 인터셉터도 달라붙지 않은 청정 상태의 순수 Dio 인스턴스를 임시로 생성
    final pureDio = Dio(
      BaseOptions(
        baseUrl: apiBaseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),
    );

    final response = await pureDio.post(
      ApiEndpoints.authReissue,
      data: {'refreshToken': refreshToken},
    );

    final data = _unwrap(response.data);
    final newAccessToken = data['accessToken'] as String;
    final newRefreshToken = data['refreshToken'] as String?;

    if (newRefreshToken != null) {
      await secureStorageService.saveRefreshToken(newRefreshToken);
    }

    // 이후 요청·STOMP 연결용 메모리 토큰 갱신
    TokenHolder.accessToken = newAccessToken;

    return newAccessToken;
  }
}

// 레포지토리를 앱 전체에 공급할 프로바이더
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  // 프로바이더 내부에서 다른 프로바이더를 관찰할 때는 관례상 watch를 사용
  final secureStorage = ref.watch(secureStorageServiceProvider);
  final dio = ref.watch(dioProvider);

  return AuthRepositoryImpl(secureStorage, dio);
});

// final authRepositoryProvider = Provider<AuthRepository>((ref) {
//   return AuthRepositoryImpl(
//     ref.read(secureStorageServiceProvider),
//     ref.read(dioProvider),
//   );
// });
