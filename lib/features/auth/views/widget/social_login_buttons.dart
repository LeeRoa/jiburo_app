import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:jiburo_app/core/utils/auth_guard.dart';
import 'package:jiburo_app/features/auth/providers/auth_provider.dart';

import 'login_button.dart';

class SocialLoginButtons extends ConsumerWidget {
  const SocialLoginButtons({super.key});

  Future<void> handleLogin(
    String type,
    BuildContext context,
    WidgetRef ref,
  ) async {
    try {
      await ref.read(authProvider.notifier).signIn(type);
      if (!context.mounted) return;
      onLoginSuccess(context); // 이전에 만든 util 함수
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('로그인 실패: $e')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          LoginButton(
            color: AppColors.kakaoYellow,
            text: "카카오 로그인",
            textColor: Colors.black,
            iconSrc: "assets/images/icons/kakaoLogo.svg",
            onTap: () => handleLogin('kakao', context, ref),
          ),
          const SizedBox(height: 8),
          LoginButton(
            color: AppColors.naverGreen,
            text: "네이버 로그인",
            textColor: Colors.white,
            iconSrc: "assets/images/icons/naverLogo.svg",
            onTap: () => handleLogin('naver', context, ref),
          ),
          const SizedBox(height: 8),
          LoginButton(
            color: Color(0xFFFFFFFF),
            text: "구글 로그인",
            textColor: Color(0x8A000000),
            iconSrc: "assets/images/icons/GoogleLogo.svg",
            border: Border.all(color: AppColors.neutral90),
            onTap: () => handleLogin('google', context, ref),
          ),
        ],
      ),
    );
  }
}
