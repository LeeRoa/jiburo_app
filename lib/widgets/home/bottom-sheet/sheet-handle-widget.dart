import 'package:flutter/material.dart';
import 'package:jiburo_app/styles/colors.dart';

class SheetHandleWidget extends StatelessWidget {
  const SheetHandleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 142,
      height: 4,
      margin: EdgeInsets.only(top: 16, bottom: 24),

      decoration: BoxDecoration(
        color: AppColors.neutral50,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
