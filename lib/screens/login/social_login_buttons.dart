import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          _loginButton(
            color: AppColors.kakaoYellow,
            text: "카카오 로그인",
            textColor: Colors.black,
            iconSrc: "assets/images/icons/kakaoLogo.svg",
            onTap: () => handleLogin('카카오'),
          ),
          const SizedBox(height: 8),
          _loginButton(
            color: AppColors.naverGreen,
            text: "네이버 로그인",
            textColor: Colors.white,
            iconSrc: "assets/images/icons/naverLogo.svg",
            onTap: () => handleLogin('네이버'),
          ),
          const SizedBox(height: 8),
          _loginButton(
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

Widget _loginButton({
  required Color color,
  required String text,
  required Color textColor,
  required String iconSrc,
  required void Function()? onTap,
  Border? border,
}) {
  return Container(
    height: 48,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(8),
      border: border ?? border,
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(iconSrc, width: 20, height: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    ),
  );
}
