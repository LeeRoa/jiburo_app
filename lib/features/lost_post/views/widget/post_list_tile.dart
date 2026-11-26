import 'package:flutter/material.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';
import 'package:jiburo_app/core/utils/formatters.dart';
import 'package:jiburo_app/core/views/widgets/reward_text.dart';
import 'package:jiburo_app/features/lost_post/dto/post_summary.dart';

/// 게시글 목록 한 줄 (사진, 제목, 위치, 반경)
/// - [compact]: 마이페이지 미리보기용 (사진 64, 사례금·시간 생략)
/// - 기본: 전체보기용 (사진 96, 사례금·등록 시간 포함)
class PostListTile extends StatelessWidget {
  final PostSummary post;
  final bool compact;
  final VoidCallback? onTap;

  const PostListTile({
    super.key,
    required this.post,
    this.compact = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = compact ? 64.0 : 96.0;
    final nearby = post.nearbyLabel;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          NetworkThumb(url: post.imageUrl, size: size),
          Expanded(
            child: SizedBox(
              height: size,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title,
                        style: AppFonts.b2nSB,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      if (post.foundLocation.isNotEmpty)
                        Text(
                          post.foundLocation,
                          style: AppFonts.l2M,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (nearby != null)
                        Text(
                          nearby,
                          style: AppFonts.c2R.copyWith(
                            color: AppColors.neutral60,
                          ),
                        ),
                      if (!compact) ...[
                        const SizedBox(height: 4),
                        RewardText(won: post.reward),
                      ],
                    ],
                  ),
                  if (!compact && post.createdAt != null)
                    Text(
                      formatRelativeTime(post.createdAt),
                      style: AppFonts.c2R.copyWith(color: AppColors.neutral60),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 네트워크 이미지 썸네일 (없거나 실패하면 기본 이미지)
class NetworkThumb extends StatelessWidget {
  final String? url;
  final double size;
  final String fallbackAsset;

  const NetworkThumb({
    super.key,
    required this.url,
    required this.size,
    this.fallbackAsset = 'assets/images/empty-img.png',
  });

  @override
  Widget build(BuildContext context) {
    final fallback = Image.asset(fallbackAsset, fit: BoxFit.cover);
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
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
