import 'package:flutter/material.dart';
import 'package:jiburo_app/screens/login/social_login_buttons.dart';
import 'package:jiburo_app/styles/fonts.dart';

class LoginSection extends StatelessWidget {
  const LoginSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(bottom: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("서비스 시작하기", style: AppFonts.hd1B),
            SizedBox(height: 20),
            SocialLoginButtons(),
          ],
        ),
      ),
    );
  }
}
