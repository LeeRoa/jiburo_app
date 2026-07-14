import 'package:flutter/material.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';

class LabelText extends StatelessWidget {
  final String label;
  final bool isImport;
  const LabelText({super.key, required this.label, required this.isImport});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: AppFonts.c1M),
        if (isImport)
          Text('*', style: AppFonts.c1M.copyWith(color: AppColors.point50)),
      ],
    );
  }
}
