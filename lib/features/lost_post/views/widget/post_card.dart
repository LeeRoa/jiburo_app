import 'package:flutter/material.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';
import 'package:jiburo_app/core/utils/formatters.dart';
import 'package:jiburo_app/core/views/widgets/buttons/icon_btn.dart';
import 'package:jiburo_app/core/views/widgets/dividing-line/dividing_line.dart';
import 'package:jiburo_app/core/views/widgets/reward_text.dart';
import 'package:jiburo_app/features/lost_post/dto/post_summary.dart';
import 'package:jiburo_app/features/lost_post/views/widget/post_list_tile.dart';

/// 홈 목록의 게시글 카드 (사진 169, 제목, 위치, 반경, 사례금, 등록 시간, 저장 하트)
class PostCard extends StatelessWidget {
  final PostSummary post;
  final bool liked;
  final VoidCallback onTap;
  final VoidCallback onLike;

  const PostCard({
    super.key,
    required this.post,
    required this.liked,
    required this.onTap,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    final nearby = post.nearbyLabel;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 185,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              spacing: 16,
              children: [
                NetworkThumb(url: post.imageUrl, size: 169),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.title,
                                style: AppFonts.b2nSB,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              if (post.foundLocation.isNotEmpty)
                                Text(
                                  post.foundLocation,
                                  style: AppFonts.l2M,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              if (nearby != null)
                                Text(nearby, style: AppFonts.c2R),
                              const SizedBox(height: 8),
                              RewardText(won: post.reward),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            formatRelativeTime(post.createdAt),
                            style: AppFonts.c2R.copyWith(
                              color: AppColors.neutral60,
                            ),
                          ),
                          IconBtn(
                            iconPath:
                                'assets/images/icons/tab-bar/ic_Save${liked ? '=Active' : ''}.svg',
                            onTap: onLike,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const DividingLine(margin: 12),
        ],
      ),
    );
  }
}
