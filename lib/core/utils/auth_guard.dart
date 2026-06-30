import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jiburo_app/core/routes/app_paths.dart';
import 'package:jiburo_app/features/auth/providers/auth_provider.dart';

// 로그인 체크
bool requireLogin(BuildContext context, WidgetRef ref) {
  final authState = ref.read(authProvider);
  final isLogin = authState.isLogin;
  final String loginPath = AppPaths.login;

  if (!isLogin) {
    //TODO: 로그인 안내 알림
    final message = authState.wasLoggedIn
        ? '로그인이 만료되었어요. 다시 로그인해주세요'
        : '로그인이 필요한 기능이에요';

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));

    final currentPath = GoRouterState.of(context).uri.toString();
    context.push('$loginPath/?redirect=${Uri.encodeComponent(currentPath)}');
    return false;
  }

  return true;
}

/// 로그인 성공 후 원래 위치로 복귀 (redirect 파라미터 없으면 홈으로)
void onLoginSuccess(BuildContext context) {
  final redirect = GoRouterState.of(context).uri.queryParameters['redirect'];
  if (redirect != null) {
    context.go(redirect);
  } else {
    context.go(AppPaths.home);
  }
}
