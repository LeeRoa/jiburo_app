import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';

class StepLabel extends StatelessWidget {
  final String step;
  final String label;
  final bool isActive;
  final bool isDone;
  const StepLabel({
    super.key,
    required this.step,
    required this.label,
    required this.isActive,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 5,
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: !isActive || isDone
              ? Alignment.center
              : Alignment.centerLeft,
          padding: !isActive || isDone ? null : EdgeInsets.only(left: 9),
          decoration: BoxDecoration(
            color: isActive ? AppColors.blue : AppColors.neutral95,
            borderRadius: BorderRadius.circular(70),
          ),
          child: !isDone
              ? Text(
                  step,
                  style: AppFonts.c1SB.copyWith(color: AppColors.white),
                )
              : SvgPicture.asset('assets/images/check.svg'),
        ),
        Text(label, style: AppFonts.c1SB),
      ],
    );
  }
}
