import 'package:flutter/material.dart';
import 'package:jiburo_app/styles/colors.dart';

class SheetBox extends StatelessWidget {
  final Widget child;
  final BorderRadius borderRadius;
  const SheetBox({super.key, required this.child, required this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 4),
            blurRadius: 4,
            spreadRadius: 10,
          ),
        ],
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}
