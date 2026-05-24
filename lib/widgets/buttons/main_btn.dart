import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiburo_app/styles/colors.dart';
import 'package:jiburo_app/styles/fonts.dart';

enum Variant {
  primary(
    bgColor: AppColors.point50,
    pressedColor: AppColors.interactionRed,
    textColor: AppColors.white,
  ),
  assistive(
    bgColor: AppColors.neutral95,
    pressedColor: AppColors.neutral80,
    textColor: AppColors.black,
  ),
  outline(
    bgColor: AppColors.white,
    pressedColor: AppColors.interactionRed,
    textColor: AppColors.point50,
    borderColor: AppColors.point50,
  ),
  outlineDark(
    bgColor: AppColors.white,
    pressedColor: AppColors.neutral80,
    textColor: AppColors.black,
    borderColor: AppColors.neutral60,
  );

  final Color bgColor;
  final Color textColor;
  final Color pressedColor;
  final Color? borderColor;

  const Variant({
    required this.bgColor,
    required this.textColor,
    required this.pressedColor,
    this.borderColor,
  });
}

enum Size {
  large(iconSize: 24, horizontalPd: 28, verticalPd: 12),
  medium(iconSize: 20, horizontalPd: 20, verticalPd: 9),
  small(iconSize: 18, horizontalPd: 14, verticalPd: 7);

  final double iconSize;
  final double horizontalPd;
  final double verticalPd;

  const Size({
    required this.iconSize,
    required this.horizontalPd,
    required this.verticalPd,
  });
}

class MainBtn extends StatefulWidget {
  final String btnName;
  final Variant variant;
  final Size size;
  final bool isDisabled;
  final String icLeft;
  final String icRight;
  final bool isExpanded;
  final bool isIconOnly;
  final double resizeBorderRadius;
  final void Function() onTap;

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
    required this.onTap,
  });

  @override
  State<MainBtn> createState() => _MainBtnState();
}

class _MainBtnState extends State<MainBtn> {
  bool _isPressed = false;

  Color get btnBgColor => widget.variant.bgColor;
  Color get btnTextColor => widget.variant.textColor;
  Color get pressedColor => widget.variant.pressedColor;
  Color get borderColor => widget.variant.borderColor!;

  TextStyle get font {
    switch (widget.size) {
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
    final verticalPd = widget.variant != Variant.outline
        ? widget.size.verticalPd + 1
        : widget.size.verticalPd;

    return GestureDetector(
      onTapDown: (_) {
        SystemSound.play(SystemSoundType.click);
        setState(() => _isPressed = true);
      },
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 120),
        width: widget.isExpanded ? double.infinity : null,

        constraints: BoxConstraints(minHeight: 32, maxHeight: 48),
        padding: widget.isIconOnly
            ? EdgeInsets.all(verticalPd)
            : EdgeInsets.symmetric(
                vertical: verticalPd,
                horizontal: widget.size.horizontalPd,
              ),
        decoration: BoxDecoration(
          color: _isPressed && widget.variant != Variant.outline
              ? pressedColor
              : widget.isDisabled
              ? AppColors.neutral99
              : btnBgColor,
          borderRadius: BorderRadius.circular(
            widget.resizeBorderRadius > 0
                ? widget.resizeBorderRadius
                : Size.medium == widget.size
                ? 10
                : 12,
          ),
          border:
              (widget.variant == Variant.outline ||
                  widget.variant == Variant.outlineDark)
              ? Border.all(
                  color: _isPressed
                      ? pressedColor
                      : widget.variant.borderColor!,
                )
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 6,
          children: [
            if (widget.icLeft != '')
              _iconWidget(
                iconSize: widget.size.iconSize,
                iconPath: widget.icLeft,
                isDisabled: widget.isDisabled,
              ),
            if (!widget.isIconOnly)
              Text(
                widget.btnName,
                style: font.copyWith(
                  color: widget.variant == Variant.outline && _isPressed
                      ? pressedColor
                      : widget.isDisabled
                      ? AppColors.neutral80
                      : btnTextColor,
                ),
              ),
            if (!widget.isIconOnly)
              if (widget.icRight != '')
                _iconWidget(
                  iconSize: widget.size.iconSize,
                  iconPath: widget.icRight,
                  isDisabled: widget.isDisabled,
                ),
          ],
        ),
      ),
    );
  }
}

Widget _iconWidget({
  required double iconSize,
  required String iconPath,
  required bool isDisabled,
}) {
  return SizedBox(
    width: iconSize,
    height: iconSize,
    child: SvgPicture.asset(
      iconPath,
      colorFilter: isDisabled
          ? ColorFilter.mode(AppColors.neutral80, BlendMode.src)
          : null,
    ),
  );
}
