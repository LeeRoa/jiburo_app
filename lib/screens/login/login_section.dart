import 'package:flutter/material.dart';
import 'package:jiburo_app/screens/login/social_login_buttons.dart';
import 'package:jiburo_app/styles/fonts.dart';

class LoginSection extends StatelessWidget {
  const LoginSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min, // 중요
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text("서비스 시작하기", style: AppFonts.hd1SB),
          SizedBox(height: 20),
          SocialLoginButtons(),
        ],
      ),
    );
  }
}
