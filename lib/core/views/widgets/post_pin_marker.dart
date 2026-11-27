import 'package:flutter/material.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';

/// 지도에 표시하는 게시글 마커 (KImage.fromWidget 으로 이미지화해서 사용)
class PostPinMarker extends StatelessWidget {
  const PostPinMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 56,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // 그림자 겸용 아래 끝 점
          Positioned(
            bottom: 0,
            child: Container(
              width: 10,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.point50,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.pets, color: AppColors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
