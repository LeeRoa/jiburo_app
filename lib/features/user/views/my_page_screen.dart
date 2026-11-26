import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jiburo_app/core/network/api_error.dart';
import 'package:jiburo_app/core/routes/app_paths.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';
import 'package:jiburo_app/core/views/widgets/app-bar/index_app_bar.dart';
import 'package:jiburo_app/core/views/widgets/buttons/main_btn.dart';
import 'package:jiburo_app/core/views/widgets/dialogs/confirm_dialog.dart';
import 'package:jiburo_app/features/auth/providers/auth_provider.dart';
import 'package:jiburo_app/features/lost_post/views/widget/post_list_tile.dart';
import 'package:jiburo_app/features/user/data/user_repository.dart';
import 'package:jiburo_app/features/user/dto/user_dtos.dart';
import 'package:jiburo_app/features/user/providers/user_providers.dart';
import 'package:jiburo_app/features/user/views/widget/activity_tile.dart';
import 'package:jiburo_app/features/user/views/widget/profile_avatar.dart';

class MyPageScreen extends ConsumerWidget {
  const MyPageScreen({super.key});

  void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _comingSoon(BuildContext context) => _toast(context, '준비 중이에요');

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final ok = await showConfirmDialog(
      context,
      message: '로그아웃 하시겠어요?',
      confirmLabel: '로그아웃',
    );
    if (ok != true) return;
    await ref.read(authProvider.notifier).signOut();
  }

  Future<void> _withdraw(BuildContext context, WidgetRef ref) async {
    final ok = await showConfirmDialog(
      context,
      message: '탈퇴하시면 계정 정보가 삭제되고 복구할 수 없어요. 정말 탈퇴하시겠어요?',
      confirmLabel: '탈퇴하기',
    );
    if (ok != true || !context.mounted) return;
    try {
      await ref.read(userRepositoryProvider).withdraw();
      await ref.read(authProvider.notifier).signOut();
      if (context.mounted) _toast(context, '탈퇴가 완료됐어요');
    } catch (e) {
      if (context.mounted) {
        _toast(context, apiErrorMessage(e, fallback: '탈퇴하지 못했어요'));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLogin = ref.watch(authProvider).isLogin;

    return Scaffold(
      backgroundColor: AppColors.neutral99,
      appBar: IndexAppBar(type: AppBarType.subNotify, title: '마이페이지'),
      body: !isLogin
          ? const _LoggedOut()
          : RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(myProfileProvider);
                ref.invalidate(myPostsProvider);
                ref.invalidate(myActivitiesProvider);
              },
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  const _ProfileCard(),
                  const SizedBox(height: 8),
                  const _LevelCard(),
                  const SizedBox(height: 8),
                  const _MyPostsCard(),
                  const SizedBox(height: 8),
                  const _MyActivitiesCard(),
                  const SizedBox(height: 8),
                  _MenuCard(
                    items: [
                      _MenuItem('계정 관리', () => _comingSoon(context)),
                      _MenuItem('알림·위치 설정', () => _comingSoon(context)),
                      _MenuItem('공지사항', () => _comingSoon(context)),
                      _MenuItem('1:1 문의하기', () => _comingSoon(context)),
                      _MenuItem('로그아웃', () => _logout(context, ref)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _MenuCard(
                    items: [
                      _MenuItem('서비스 이용약관', () => _comingSoon(context)),
                      _MenuItem('개인정보처리방침', () => _comingSoon(context)),
                      _MenuItem('위치기반서비스 이용약관', () => _comingSoon(context)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _MenuCard(
                    items: [
                      _MenuItem(
                        '회원탈퇴',
                        () => _withdraw(context, ref),
                        muted: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

class _LoggedOut extends StatelessWidget {
  const _LoggedOut();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          Text(
            '로그인하고 내 활동을 확인해 보세요',
            style: AppFonts.b1nM.copyWith(color: AppColors.neutral60),
          ),
          MainBtn(
            btnName: '로그인',
            size: Size.small,
            onTap: () => context.push(
              '${AppPaths.login}/?redirect=${Uri.encodeComponent(AppPaths.profile)}',
            ),
          ),
        ],
      ),
    );
  }
}

/// 흰 배경 둥근 카드
class _Card extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const _Card({required this.child, this.padding = const EdgeInsets.all(16)});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onMore;
  const _SectionHeader({required this.title, required this.onMore});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppFonts.b2nSB),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onMore,
          child: Text(
            '전체보기',
            style: AppFonts.c1R.copyWith(color: AppColors.neutral60),
          ),
        ),
      ],
    );
  }
}

class _ProfileCard extends ConsumerWidget {
  const _ProfileCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(myProfileProvider);
    return _Card(
      child: profile.when(
        loading: () => const SizedBox(
          height: 48,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        error: (e, _) => Row(
          children: [
            Expanded(
              child: Text(
                '프로필을 불러오지 못했어요',
                style: AppFonts.b2nM.copyWith(color: AppColors.neutral60),
              ),
            ),
            TextButton(
              onPressed: () => ref.invalidate(myProfileProvider),
              child: const Text('다시 시도'),
            ),
          ],
        ),
        data: (p) => Row(
          spacing: 12,
          children: [
            ProfileAvatar(url: p.profileImageUrl, size: 48),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.nickname,
                    style: AppFonts.b1nSB,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    p.providerLabel,
                    style: AppFonts.c1R.copyWith(color: AppColors.neutral60),
                  ),
                ],
              ),
            ),
            MainBtn(
              btnName: '프로필 수정',
              variant: Variant.black,
              size: Size.small,
              onTap: () => context.push(AppPaths.profileEdit),
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelCard extends ConsumerWidget {
  const _LevelCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(myProfileProvider).valueOrNull;
    final level = profile?.level ?? 1;
    final xp = profile?.xp ?? 0;
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Text('내 레벨', style: AppFonts.b2nSB),
          Row(
            spacing: 12,
            children: [
              Text(
                'LV. $level',
                style: AppFonts.b2nSB.copyWith(color: AppColors.point50),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: LinearProgressIndicator(
                    value: xp / UserProfile.xpPerLevel,
                    minHeight: 8,
                    backgroundColor: AppColors.neutral95,
                    color: AppColors.point50,
                  ),
                ),
              ),
              Text(
                'XP $xp/${UserProfile.xpPerLevel}',
                style: AppFonts.c2R.copyWith(color: AppColors.neutral60),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MyPostsCard extends ConsumerWidget {
  const _MyPostsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(myPostsProvider(3));
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          _SectionHeader(
            title: '내 게시물',
            onMore: () => context.push(AppPaths.myPosts),
          ),
          posts.when(
            loading: () => const _CardLoading(),
            error: (e, _) =>
                _CardError(onRetry: () => ref.invalidate(myPostsProvider)),
            data: (page) => page.items.isEmpty
                ? const _CardEmpty('아직 등록한 게시물이 없어요')
                : Column(
                    spacing: 12,
                    children: [
                      for (final post in page.items)
                        PostListTile(
                          post: post,
                          compact: true,
                          onTap: () =>
                              context.push(AppPaths.postDetail(post.id)),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _MyActivitiesCard extends ConsumerWidget {
  const _MyActivitiesCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = ref.watch(myActivitiesProvider(3));
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          _SectionHeader(
            title: '내 활동',
            onMore: () => context.push(AppPaths.myActivities),
          ),
          activities.when(
            loading: () => const _CardLoading(),
            error: (e, _) =>
                _CardError(onRetry: () => ref.invalidate(myActivitiesProvider)),
            data: (items) => items.isEmpty
                ? const _CardEmpty('아직 탐색 활동이 없어요')
                : Column(
                    spacing: 12,
                    children: [
                      for (final a in items)
                        ActivityTile(
                          activity: a,
                          onTap: () =>
                              context.push(AppPaths.postDetail(a.postId)),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _CardLoading extends StatelessWidget {
  const _CardLoading();

  @override
  Widget build(BuildContext context) => const SizedBox(
    height: 48,
    child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
  );
}

class _CardEmpty extends StatelessWidget {
  final String text;
  const _CardEmpty(this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(text, style: AppFonts.c1R.copyWith(color: AppColors.neutral60)),
  );
}

class _CardError extends StatelessWidget {
  final VoidCallback onRetry;
  const _CardError({required this.onRetry});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Text(
        '불러오지 못했어요',
        style: AppFonts.c1R.copyWith(color: AppColors.neutral60),
      ),
      TextButton(onPressed: onRetry, child: const Text('다시 시도')),
    ],
  );
}

class _MenuItem {
  final String label;
  final VoidCallback onTap;
  final bool muted;
  const _MenuItem(this.label, this.onTap, {this.muted = false});
}

class _MenuCard extends StatelessWidget {
  final List<_MenuItem> items;
  const _MenuCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          for (final item in items)
            InkWell(
              onTap: item.onTap,
              child: Container(
                height: 44,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.label,
                        style: AppFonts.b2nM.copyWith(
                          color: item.muted
                              ? AppColors.neutral60
                              : AppColors.neutral20,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: AppColors.neutral70,
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
