import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jiburo_app/core/routes/app_paths.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';

import 'social_login_buttons.dart';

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
            SizedBox(height: 8),
            TextButton(
              onPressed: () {
                context.go(AppPaths.home);
              },
              child: Text(
                "홈으로 이동",
                style: AppFonts.l2M.copyWith(color: AppColors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
