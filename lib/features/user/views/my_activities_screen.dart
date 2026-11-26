import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jiburo_app/core/routes/app_paths.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';
import 'package:jiburo_app/core/views/widgets/app-bar/index_app_bar.dart';
import 'package:jiburo_app/core/views/widgets/plain_layout.dart';
import 'package:jiburo_app/features/user/providers/user_providers.dart';
import 'package:jiburo_app/features/user/views/widget/activity_tile.dart';

/// 내 활동(탐색 세션) 전체보기
class MyActivitiesScreen extends ConsumerWidget {
  const MyActivitiesScreen({super.key});

  static const _pageSize = 50;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = ref.watch(myActivitiesProvider(_pageSize));
    return PlainLayout(
      appBar: IndexAppBar(type: AppBarType.notify, title: '내 활동'),
      body: activities.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: TextButton(
            onPressed: () => ref.invalidate(myActivitiesProvider),
            child: const Text('불러오지 못했어요. 다시 시도'),
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Text(
                '아직 탐색 활동이 없어요',
                style: AppFonts.b1nM.copyWith(color: AppColors.neutral60),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(myActivitiesProvider),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (context, i) => ActivityTile(
                activity: items[i],
                onTap: () => context.push(AppPaths.postDetail(items[i].postId)),
              ),
            ),
          );
        },
      ),
    );
  }
}
