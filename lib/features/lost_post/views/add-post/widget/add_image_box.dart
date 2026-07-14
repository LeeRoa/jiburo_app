import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';

class AddImageBox extends StatelessWidget {
  final String imgPath;
  final bool isMain;
  const AddImageBox({super.key, required this.imgPath, this.isMain = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: isMain
            ? Border.all(color: AppColors.point50, width: 1.5)
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isMain ? 6.5 : 8),
        child: Stack(
          children: [
            Positioned.fill(child: Image.asset(imgPath, fit: BoxFit.cover)),
            Positioned(
              top: 4,
              right: 4,
              width: 16,
              height: 16,
              child: SvgPicture.asset(
                'assets/images/icons/ic_Cancel=circle.svg',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
