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

  Future<void> logout() async {
    await ref.read(secureStorageServiceProvider).deleteRefreshToken();
    state = state.copyWith(accessToken: null, isLogin: false);
    // wasLoggedIn은 그대로 true 유지
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
