import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jiburo_app/styles/colors.dart';
import 'package:jiburo_app/styles/fonts.dart';

class CountLabel extends StatefulWidget {
  final int count;
  final int total;
  const CountLabel({super.key, required this.count, required this.total});

  @override
  State<CountLabel> createState() => _CountLabelState();
}

class _CountLabelState extends State<CountLabel> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.neutral50.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(40),
          // gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomRight,
          //   colors: [
          //     AppColors.neutral50.withValues(alpha: 0.8),
          //     AppColors.neutral50.withValues(alpha: 0.8),
          //     Colors.transparent,
          //   ],
          // ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 4,
          children: [
            Text(
              '${widget.count}',
              style: AppFonts.l2SB.copyWith(color: AppColors.white),
            ),
            Text(
              '/',
              style: AppFonts.l2SB.copyWith(color: AppColors.neutral90),
            ),
            Text(
              '${widget.total}',
              style: AppFonts.l2SB.copyWith(color: AppColors.white),
            ),
          ],
        ),
      ),
    );
  }
}

// return ShaderMask(
// shaderCallback: (bounds) => LinearGradient(
// begin: Alignment.topCenter,
// end: Alignment.bottomCenter,
// colors: [Colors.transparent, Colors.white],
// stops: [0.0, 1.0],
// ).createShader(bounds),
// blendMode: BlendMode.dstIn,
// child: BackdropFilter(
// filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
// child: IntrinsicWidth(
// child: Container(
// decoration: BoxDecoration(
// color: AppColors.neutral50.withValues(alpha: 0.8),
// borderRadius: BorderRadius.circular(40),
// ),
// padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
// child: Row(
// crossAxisAlignment: CrossAxisAlignment.center,
// mainAxisAlignment: MainAxisAlignment.center,
// spacing: 4,
// children: [
// Text(
// '1',
// style: AppFonts.l2SB.copyWith(color: AppColors.white),
// ),
// Text(
// '/',
// style: AppFonts.l2SB.copyWith(color: AppColors.neutral90),
// ),
// Text(
// '10',
// style: AppFonts.l2SB.copyWith(color: AppColors.white),
// ),
// ],
// ),
// ),
// ),
// ),
// );
