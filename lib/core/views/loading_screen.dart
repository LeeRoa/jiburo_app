import 'package:flutter/material.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';
import 'package:lottie/lottie.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.white),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LottieBuilder.asset(
              "assets/lottie/loading.json",
              width: 120,
              height: 120,
            ),
            SizedBox(height: 12),
            DefaultTextStyle(
              style: AppFonts.b1nM.copyWith(color: AppColors.neutral80),
              child: Text('잠시만 기다려 주세요'),
            ),
          ],
        ),
      ),
    );
  }
}
