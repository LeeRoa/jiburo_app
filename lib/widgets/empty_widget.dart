import 'package:flutter/material.dart';
import 'package:jiburo_app/styles/colors.dart';
import 'package:jiburo_app/styles/fonts.dart';

class EmptyWidget extends StatelessWidget {
  final String text;
  final String imgPath;
  const EmptyWidget({super.key, required this.text, required this.imgPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 120),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(child: Image.asset(imgPath)),
          SizedBox(height: 12),
          Text(text, style: AppFonts.b1nM.copyWith(color: AppColors.neutral80)),
        ],
      ),
    );
  }
}
