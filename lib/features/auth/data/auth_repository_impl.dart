import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:jiburo_app/core/network/api_endpoints.dart';
import 'package:jiburo_app/core/network/dio_client.dart';
import 'package:jiburo_app/core/network/token_holder.dart';
import 'package:jiburo_app/core/storage/secure_storage_service.dart';
import 'package:jiburo_app/features/auth/domain/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio dio;
  final SecureStorageService secureStorageService;

  AuthRepositoryImpl(this.secureStorageService, this.dio);

  @override
  Future<void> signIn(String type) async {
    final result = await FlutterWebAuth2.authenticate(
      url: 'http://localhost:8080/oauth2/authorization/$type',
      callbackUrlScheme: 'jiburo',
      // options: FlutterWebAuth2Options(preferEphemeral: true),
    );

    final uri = Uri.parse(result);
    final accessToken = uri.queryParameters['accessToken'];
    final refreshToken = uri.queryParameters['refreshToken'];

    if (accessToken == null) {
      throw Exception('로그인 실패: accessToken 없음');
    }

    TokenHolder.accessToken = accessToken;

    if (refreshToken != null) {
      await secureStorageService.saveRefreshToken(refreshToken);
    }
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
        baseUrl: 'http://localhost:8080',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),
    );

    final response = await pureDio.post(
      ApiEndpoints.authReissue,
      data: {'refreshToken': refreshToken},
    );

    final newAccessToken = response.data['accessToken'] as String;
    final newRefreshToken = response.data['refreshToken'] as String?;

    if (newRefreshToken != null) {
      await secureStorageService.saveRefreshToken(newRefreshToken);
    }

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
