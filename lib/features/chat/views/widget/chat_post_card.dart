import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jiburo_app/core/routes/app_paths.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';
import 'package:jiburo_app/core/utils/formatters.dart';
import 'package:jiburo_app/core/views/widgets/dividing-line/dividing_line.dart';
import 'package:jiburo_app/core/views/widgets/reward_text.dart';
import 'package:jiburo_app/features/chat/dto/chat_dtos.dart';
import 'package:jiburo_app/features/chat/providers/chat_providers.dart';
import 'package:jiburo_app/features/lost_post/dto/post_summary.dart';

/// 채팅방 상단 게시글 카드 (사진, 제목, 위치, 반경, 사례금, 등록 시간)
/// - 상세 정보 로딩 중이거나 실패하면 채팅방 응답의 제목만 표시
/// - 삭제된 게시글은 안내 문구만 표시
class ChatPostCard extends ConsumerWidget {
  final ChatRoomDetail detail;
  const ChatPostCard({super.key, required this.detail});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (detail.postDeleted) {
      return const _DeletedPost();
    }

    final post = ref.watch(chatPostProvider(detail.postId)).valueOrNull;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push(AppPaths.postDetail(detail.postId)),
      child: Column(
        children: [
          Container(
            height: 120,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              spacing: 16,
              children: [
                _Thumbnail(imageUrl: post?.imageUrl),
                Expanded(
                  child: _Info(title: detail.postTitle, post: post),
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

class _Thumbnail extends StatelessWidget {
  final String? imageUrl;
  const _Thumbnail({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    const empty = 'assets/images/empty-img.png';
    return Container(
      width: 104,
      height: 104,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: imageUrl == null
          ? Image.asset(empty, fit: BoxFit.cover)
          : Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Image.asset(empty, fit: BoxFit.cover),
            ),
    );
  }
}

class _Info extends StatelessWidget {
  final String title;
  final PostSummary? post;
  const _Info({required this.title, required this.post});

  @override
  Widget build(BuildContext context) {
    final reward = post?.reward;
    final nearby = post?.nearbyLabel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppFonts.b2nSB,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            if (post != null && post!.foundLocation.isNotEmpty)
              Text(post!.foundLocation, style: AppFonts.l2M),
            if (nearby != null) Text(nearby, style: AppFonts.c2R),
            if (reward != null && reward > 0) ...[
              const SizedBox(height: 8),
              RewardText(won: reward),
            ],
          ],
        ),
        if (post?.createdAt != null)
          Text(
            formatRelativeTime(post!.createdAt),
            style: AppFonts.c2R.copyWith(color: AppColors.neutral60),
          ),
      ],
    );
  }
}

class _DeletedPost extends StatelessWidget {
  const _DeletedPost();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.neutral99,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '삭제된 게시글이에요',
        style: AppFonts.b2nM.copyWith(color: AppColors.neutral60),
      ),
    );
  }
}
