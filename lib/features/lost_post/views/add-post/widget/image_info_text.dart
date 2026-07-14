import 'package:flutter/material.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';

class ImageInfoText extends StatelessWidget {
  final String mainText;
  final String subText;
  const ImageInfoText({
    super.key,
    required this.mainText,
    required this.subText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 4),
      child: Column(
        spacing: 4,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(mainText, style: AppFonts.l2M),
          Text(
            subText,
            style: AppFonts.c1M.copyWith(color: AppColors.neutral60),
          ),
        ],
      ),
    );
  }
}
