import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiburo_app/styles/colors.dart';
import 'package:jiburo_app/styles/fonts.dart';

enum Variant {
  primary(bgColor: AppColors.point50, textColor: AppColors.white),
  assistive(bgColor: AppColors.neutral95, textColor: AppColors.black),
  outline(bgColor: AppColors.white, textColor: AppColors.point50);

  final Color bgColor;
  final Color textColor;

  const Variant({required this.bgColor, required this.textColor});
}

enum Size {
  large(height: 48, iconSize: 24, horizontalPd: 28, verticalPd: 12),
  medium(height: 40, iconSize: 20, horizontalPd: 20, verticalPd: 9),
  small(height: 32, iconSize: 18, horizontalPd: 14, verticalPd: 7);

  final double height;
  final double iconSize;
  final double horizontalPd;
  final double verticalPd;

  const Size({
    required this.height,
    required this.iconSize,
    required this.horizontalPd,
    required this.verticalPd,
  });
}

class MainBtn extends StatelessWidget {
  final String btnName;
  final Variant variant;
  final Size size;
  final bool isDisabled;
  final String icLeft;
  final String icRight;
  final bool isExpanded;
  final bool isIconOnly;
  final double resizeBorderRadius;

  const MainBtn({
    super.key,
    required this.btnName,
    this.variant = Variant.primary,
    this.size = Size.large,
    this.isDisabled = false,
    this.icLeft = "",
    this.icRight = "",
    this.isExpanded = false,
    this.isIconOnly = false,
    this.resizeBorderRadius = 0,
  });

  Color get btnBgColor => variant.bgColor;
  Color get btnTextColor => variant.textColor;

  TextStyle get font {
    switch (size) {
      case Size.large:
        return AppFonts.b1nSB;
      case Size.medium:
        return AppFonts.b2nSB;
      case Size.small:
        return AppFonts.l2SB;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: isExpanded ? double.infinity : null,
        height: size.height,
        padding: isIconOnly
            ? EdgeInsets.all(size.verticalPd)
            : EdgeInsets.symmetric(
                vertical: size.verticalPd,
                horizontal: size.horizontalPd,
              ),
        decoration: BoxDecoration(
          color: isDisabled ? AppColors.white : btnBgColor,
          borderRadius: BorderRadius.circular(
            resizeBorderRadius > 0
                ? resizeBorderRadius
                : Variant.primary == variant
                ? 12
                : 10,
          ),
          border: Variant.outline == variant
              ? Border.all(color: AppColors.point50)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 6,
          children: [
            SizedBox(
              width: size.iconSize,

              child: icLeft != ""
                  ? _iconWidget(iconPath: icLeft, isDisabled: isDisabled)
                  : null,
            ),
            if (!isIconOnly)
              Text(
                btnName,
                style: font.copyWith(
                  color: isDisabled ? AppColors.neutral80 : btnTextColor,
                ),
              ),
            if (!isIconOnly)
              SizedBox(
                width: size.iconSize,
                child: icRight != ""
                    ? _iconWidget(iconPath: icRight, isDisabled: isDisabled)
                    : null,
              ),
          ],
        ),
      ),
    );
  }
}

Widget _iconWidget({required String iconPath, required bool isDisabled}) {
  return SvgPicture.asset(
    iconPath,
    colorFilter: isDisabled
        ? ColorFilter.mode(AppColors.neutral80, BlendMode.src)
        : null,
  );
}
