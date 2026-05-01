import 'package:flutter/material.dart';
import 'package:jiburo_app/screens/login/widget/login_button.dart';
import 'package:jiburo_app/styles/colors.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  void handleLogin(String type) {
    print(type);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          LoginButton(
            color: AppColors.kakaoYellow,
            text: "카카오 로그인",
            textColor: Colors.black,
            iconSrc: "assets/images/icons/kakaoLogo.svg",
            onTap: () => handleLogin('카카오'),
          ),
          const SizedBox(height: 8),
          LoginButton(
            color: AppColors.naverGreen,
            text: "네이버 로그인",
            textColor: Colors.white,
            iconSrc: "assets/images/icons/naverLogo.svg",
            onTap: () => handleLogin('네이버'),
          ),
          const SizedBox(height: 8),
          LoginButton(
            color: Color(0xFFFFFFFF),
            text: "구글 로그인",
            textColor: Color(0x8A000000),
            iconSrc: "assets/images/icons/GoogleLogo.svg",
            border: Border.all(color: AppColors.neutral90),
            onTap: () => handleLogin('구글'),
          ),
        ],
      ),
    );
  }
}
