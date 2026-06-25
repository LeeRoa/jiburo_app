import 'package:flutter/material.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';

class CompleteCover extends StatelessWidget {
  const CompleteCover({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.black.withValues(alpha: 0.8),
        ),
        child: Text(
          '찾기 완료된 게시물이예요',
          style: AppFonts.l1nM.copyWith(color: AppColors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
