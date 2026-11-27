import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jiburo_app/core/routes/app_paths.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';
import 'package:jiburo_app/core/utils/auth_guard.dart';
import 'package:jiburo_app/core/views/widgets/empty_widget.dart';
import 'package:jiburo_app/features/lost_post/providers/post_providers.dart';
import 'package:jiburo_app/features/lost_post/views/widget/post_card.dart';

/// 저장(관심)한 게시글 목록
class SaveScreen extends ConsumerWidget {
  const SaveScreen({super.key});

  static const _empty = EmptyWidget(
    text: '찾아줄 친구를 저장해주세요',
    imgPath: 'assets/images/heart.png',
    btnText: '찾아주러 가기',
  );

  Future<void> _unsave(BuildContext context, WidgetRef ref, String id) async {
    if (!requireLogin(context, ref)) return;
    try {
      await ref.read(likedPostIdsProvider.notifier).toggle(id);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('저장을 해제하지 못했어요')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(likedPostsProvider);
    final liked =
        ref.watch(likedPostIdsProvider).valueOrNull ?? const <String>{};

    return Scaffold(
      appBar: AppBar(
        title: Text('저장', style: AppFonts.hd2B),
        centerTitle: true,
      ),
      body: saved.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: TextButton(
            onPressed: () => ref.invalidate(likedPostsProvider),
            child: const Text('저장한 게시글을 불러오지 못했어요. 다시 시도'),
          ),
        ),
        data: (items) => items.isEmpty
            ? _empty
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final post = items[i];
                  return PostCard(
                    post: post,
                    liked: liked.contains(post.id),
                    onTap: () => context.push(AppPaths.postDetail(post.id)),
                    onLike: () => _unsave(context, ref, post.id),
                  );
                },
              ),
      ),
    );
  }
}
