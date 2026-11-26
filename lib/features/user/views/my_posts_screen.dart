import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jiburo_app/core/routes/app_paths.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';
import 'package:jiburo_app/core/views/widgets/app-bar/index_app_bar.dart';
import 'package:jiburo_app/core/views/widgets/dividing-line/dividing_line.dart';
import 'package:jiburo_app/core/views/widgets/plain_layout.dart';
import 'package:jiburo_app/core/views/widgets/tabs/tab_widget.dart';
import 'package:jiburo_app/features/lost_post/dto/post_summary.dart';
import 'package:jiburo_app/features/lost_post/views/widget/post_list_tile.dart';
import 'package:jiburo_app/features/user/providers/user_providers.dart';

/// 내 게시물 전체보기 (거리순 / 최신순)
class MyPostsScreen extends ConsumerStatefulWidget {
  const MyPostsScreen({super.key});

  @override
  ConsumerState<MyPostsScreen> createState() => _MyPostsScreenState();
}

class _MyPostsScreenState extends ConsumerState<MyPostsScreen> {
  static const _pageSize = 50;
  bool _byDistance = true;

  /// 거리순: 내 위치를 알 때만 정렬 (모르면 서버가 준 최신순 그대로)
  List<PostSummary> _sorted(List<PostSummary> posts) {
    final list = [...posts];
    if (!_byDistance) return list;
    list.sort((a, b) {
      final da = a.distanceFromMeKm;
      final db = b.distanceFromMeKm;
      if (da == null && db == null) return 0;
      if (da == null) return 1;
      if (db == null) return -1;
      return da.compareTo(db);
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(myPostsProvider(_pageSize));
    return PlainLayout(
      appBar: IndexAppBar(type: AppBarType.notify, title: '내 게시물'),
      body: Column(
        spacing: 8,
        children: [
          TabWidget(
            firstLabel: '거리순',
            firstIsActive: _byDistance,
            firstOnTap: () => setState(() => _byDistance = true),
            secondLabel: '최신순',
            secondIsActive: !_byDistance,
            secondOnTap: () => setState(() => _byDistance = false),
          ),
          Expanded(
            child: posts.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: TextButton(
                  onPressed: () => ref.invalidate(myPostsProvider),
                  child: const Text('불러오지 못했어요. 다시 시도'),
                ),
              ),
              data: (page) {
                if (page.items.isEmpty) {
                  return Center(
                    child: Text(
                      '아직 등록한 게시물이 없어요',
                      style: AppFonts.b1nM.copyWith(color: AppColors.neutral60),
                    ),
                  );
                }
                final items = _sorted(page.items);
                return RefreshIndicator(
                  onRefresh: () async => ref.invalidate(myPostsProvider),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const DividingLine(margin: 12),
                    itemBuilder: (context, i) => PostListTile(
                      post: items[i],
                      onTap: () =>
                          context.push(AppPaths.postDetail(items[i].id)),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
