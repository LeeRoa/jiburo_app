import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconBtn extends StatelessWidget {
  final String iconPath;
  final double width;
  final double height;
  final void Function() onTap;
  const IconBtn({
    super.key,
    required this.iconPath,
    required this.onTap,
    this.width = 24,
    this.height = 24,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: height,
        child: SvgPicture.asset(iconPath),
      ),
    );
  }
}
