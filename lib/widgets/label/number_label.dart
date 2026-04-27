import 'package:flutter/material.dart';
import 'package:jiburo_app/styles/colors.dart';
import 'package:jiburo_app/styles/fonts.dart';

class NumberLabel extends StatelessWidget {
  final String number;
  const NumberLabel({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.neutral60,
        borderRadius: BorderRadius.circular(60),
      ),
      child: Text(
        number,
        style: AppFonts.l2SB.copyWith(color: AppColors.white),
      ),
    );
  }
}
