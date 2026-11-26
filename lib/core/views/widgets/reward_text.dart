import 'package:flutter/material.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';
import 'package:jiburo_app/core/utils/formatters.dart';

/// 사례금 표시 (사례금 : 30만원). [won]은 원 단위, 0 이하이면 표시하지 않음
class RewardText extends StatelessWidget {
  final int? won;
  const RewardText({super.key, required this.won});

  @override
  Widget build(BuildContext context) {
    final value = won;
    if (value == null || value <= 0) return const SizedBox.shrink();
    final parts = formatRewardParts(value);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('사례금 : ', style: AppFonts.l2M),
        Text(
          parts.amount,
          style: AppFonts.l2M.copyWith(color: AppColors.point50),
        ),
        Text(
          parts.unit,
          style: AppFonts.l2M.copyWith(color: AppColors.neutral60),
        ),
      ],
    );
  }
}
