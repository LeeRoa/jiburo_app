import 'package:flutter/material.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';

class DividingLine extends StatelessWidget {
  final double margin;
  const DividingLine({super.key, required this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 1,
      margin: EdgeInsets.symmetric(vertical: margin),
      decoration: BoxDecoration(color: AppColors.neutral95),
    );
  }
}
