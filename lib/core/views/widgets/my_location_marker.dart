import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';

class MyLocationMarker extends StatelessWidget {
  const MyLocationMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 113,
      height: 113,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. 부채꼴 (방향광)
          CustomPaint(size: const Size(113, 113), painter: _DirectionPainter()),
          // 2. 중심 원 (파란 점)
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: AppColors.blue,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: AppColors.blue.withValues(alpha: 0.3),
                  blurRadius: 4,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DirectionPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.38;

    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.blue.withValues(alpha: 0.5),
          AppColors.blue.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: size.width / 2));

    // SVG rotate(-30) 기준 → 약 40도 부채꼴, 위쪽 중앙 정렬
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2 - pi / 9, // 시작: 12시 기준 -20도
      pi / 4.5, // 범위: 40도
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
