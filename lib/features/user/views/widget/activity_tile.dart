import 'package:flutter/material.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';
import 'package:jiburo_app/features/lost_post/views/widget/post_list_tile.dart';
import 'package:jiburo_app/features/user/dto/user_dtos.dart';

/// 내 활동 한 줄 (탐색 세션: 썸네일, '탐색', 대상 게시글 제목, 날짜)
class ActivityTile extends StatelessWidget {
  final MyActivity activity;
  final VoidCallback? onTap;
  const ActivityTile({super.key, required this.activity, this.onTap});

  String get _date {
    final d = activity.createdAt;
    return d == null ? '' : '${d.year}. ${d.month}. ${d.day}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        spacing: 12,
        children: [
          NetworkThumb(
            url: activity.postImageUrl,
            size: 64,
            fallbackAsset: 'assets/images/map_skeleton.png',
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('탐색', style: AppFonts.b2nSB),
                const SizedBox(height: 2),
                Text(
                  activity.postTitle,
                  style: AppFonts.l2M,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _date,
                  style: AppFonts.c2R.copyWith(color: AppColors.neutral60),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
