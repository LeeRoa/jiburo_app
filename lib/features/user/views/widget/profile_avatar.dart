import 'package:flutter/material.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';

/// 프로필 사진 (없거나 불러오기 실패하면 기본 이미지)
class ProfileAvatar extends StatelessWidget {
  final String? url;
  final double size;
  const ProfileAvatar({super.key, required this.url, this.size = 48});

  @override
  Widget build(BuildContext context) {
    final fallback = Image.asset(
      'assets/images/empty-img.png',
      fit: BoxFit.cover,
    );
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.neutral95,
      ),
      child: url == null
          ? fallback
          : Image.network(
              url!,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => fallback,
            ),
    );
  }
}
