import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';

class ImageInfoBox extends StatelessWidget {
  final bool isFront;
  const ImageInfoBox({super.key, required this.isFront});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 160,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.neutral99,
        ),
        child: Column(
          spacing: 16,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 4,
              children: [
                SvgPicture.asset('assets/images/icons/ic_Success.svg'),
                Text(isFront ? '정면 사진' : '옆모습 사진', style: AppFonts.l1nSB),
              ],
            ),
            Image.asset('assets/images/pet-${isFront ? "front" : "side"}.png'),
          ],
        ),
      ),
    );
  }
}
