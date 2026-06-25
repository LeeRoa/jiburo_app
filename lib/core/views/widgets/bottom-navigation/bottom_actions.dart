import 'package:flutter/material.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';
import 'package:jiburo_app/core/views/widgets/buttons/main_btn.dart';

class BottomActions extends StatelessWidget {
  final String? guideText;
  final MainBtn mainBtn;
  final Widget? subBtn;
  final bool isRow;

  const BottomActions.full({
    super.key,
    required this.mainBtn,
    this.guideText,
    required this.subBtn,
  }) : isRow = false;

  const BottomActions.textMain({
    super.key,
    required this.guideText,
    required this.mainBtn,
  }) : isRow = false,
       subBtn = null;

  const BottomActions.single({super.key, required this.mainBtn})
    : guideText = null,
      isRow = false,
      subBtn = null;

  const BottomActions.row({
    super.key,
    required this.mainBtn,
    required this.subBtn,
  }) : guideText = null,
       isRow = true;

  @override
  Widget build(BuildContext context) {
    final sub = subBtn;

    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 14),
      child: Column(
        spacing: 16,
        children: [
          if (guideText != null)
            Text(
              guideText!,
              style: AppFonts.c2R.copyWith(color: AppColors.neutral70),
            ),
          Row(
            spacing: 8,
            children: [
              if (!isRow && sub != null) sub,
              if (isRow && sub != null) Expanded(child: sub),
              Expanded(child: mainBtn),
            ],
          ),
        ],
      ),
    );
  }
}
