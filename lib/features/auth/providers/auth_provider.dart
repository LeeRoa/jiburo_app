import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiburo_app/core/network/token_holder.dart';
import 'package:jiburo_app/core/storage/secure_storage_service.dart';
import 'package:jiburo_app/features/auth/data/auth_repository_impl.dart';

class AuthState {
  final String? accessToken;
  final bool isLogin;
  final bool wasLoggedIn;

  AuthState({this.accessToken, this.isLogin = false, this.wasLoggedIn = false});

  AuthState copyWith({String? accessToken, bool? isLogin, bool? wasLoggedIn}) {
    return AuthState(
      accessToken: accessToken ?? this.accessToken,
      isLogin: isLogin ?? this.isLogin,
      wasLoggedIn: wasLoggedIn ?? this.wasLoggedIn,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => AuthState(isLogin: TokenHolder.accessToken != null);

  void setAccessToken(String token) {
    state = state.copyWith(
      accessToken: token,
      isLogin: true,
      wasLoggedIn: true,
    );
  }

  Future<void> signIn(String type) async {
    await ref.read(authRepositoryProvider).signIn(type);
    state = state.copyWith(accessToken: TokenHolder.accessToken, isLogin: true);
  }

  Future<void> devSignIn(String nickname) async {
    await ref.read(authRepositoryProvider).devSignIn(nickname);
    state = state.copyWith(
      accessToken: TokenHolder.accessToken,
      isLogin: true,
      wasLoggedIn: true,
    );
  }

  /// 자동 로그인 (앱 시작 시 저장된 리프레시 토큰으로 로그인 상태 복원)
  /// - 토큰 없음: 로그아웃 상태 유지
  /// - 서버 거절(만료·폐기): 저장 토큰 삭제
  /// - 네트워크 오류: 토큰 유지 후 다음 실행 시 재시도
  Future<void> restoreSession() async {
    if (state.isLogin) return;
    final storage = ref.read(secureStorageServiceProvider);

    // 보안 저장소 읽기 실패(키 손상 등) 시에도 앱 시작 차단 방지
    String? refreshToken;
    try {
      refreshToken = await storage.getRefreshToken();
    } catch (_) {
      return;
    }
    if (refreshToken == null) return;

    try {
      final accessToken = await ref.read(authRepositoryProvider).reissue();
      state = state.copyWith(
        accessToken: accessToken,
        isLogin: true,
        wasLoggedIn: true,
      );
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status != null && status >= 400 && status < 500) {
        await storage.deleteRefreshToken();
      }
    } catch (_) {
      // 그 외 오류: 로그아웃 상태로 시작
    }
  }

  Future<void> logout() async {
    await ref.read(secureStorageServiceProvider).deleteRefreshToken();
    TokenHolder.accessToken = null;
    state = AuthState(wasLoggedIn: state.wasLoggedIn);
    // wasLoggedIn은 그대로 true 유지
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
