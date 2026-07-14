import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jiburo_app/core/routes/app_paths.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';
import 'package:jiburo_app/core/views/widgets/app-bar/custom_app_bar.dart';
import 'package:jiburo_app/core/views/widgets/buttons/custom_back_btn.dart';
import 'package:jiburo_app/core/views/widgets/buttons/icon_btn.dart';
import 'package:jiburo_app/features/lost_post/providers/add_post_provider.dart';
import 'package:jiburo_app/features/notification/providers/notification_provider.dart';

enum AppBarType { home, detail, sub, notify, subNotify, addPost }

class IndexAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBarType type;
  final String? title;
  final VoidCallback? onMenu;
  final bool? isFirst;
  final bool? isSearch;
  const IndexAppBar({
    super.key,
    required this.type,
    this.title,
    this.onMenu,
    this.isFirst = false,
    this.isSearch = false,
  });

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      AppBarType.home => _HomeAppBar(),
      AppBarType.detail => _DetailAppBar(onTap: onMenu!, title: title!),
      AppBarType.sub => _SubAppBar(title: title!, onTap: onMenu!),
      AppBarType.notify => _NotifyAppBar(title: title!),
      AppBarType.subNotify => _SubNotifyAppBar(title: title!),
      AppBarType.addPost => _AddPostAppBar(
        title: title!,
        isFirst: isFirst!,
        isSearch: isSearch!,
      ),
    };
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

class _HomeAppBar extends ConsumerWidget {
  const _HomeAppBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNew = ref.watch(notificationProvider);
    return CustomAppBar(
      isHome: true,
      actions: [
        IconBtn(
          iconPath: isNew
              ? 'assets/images/icons/ic_status=new.svg'
              : 'assets/images/icons/ic_status=normal.svg',
          onTap: () {
            context.push(AppPaths.notify);
          },
        ),
      ],
    );
  }
}

// 뒤로가기 + 타이틀 + 메뉴버튼
class _DetailAppBar extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const _DetailAppBar({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      isHome: false,
      titleText: title,
      leading: CustomBackBtn(),
      actions: [
        IconBtn(onTap: onTap, iconPath: 'assets/images/icons/ic_Etc.svg'),
      ],
    );
  }
}

// 타이틀 + 메뉴버튼
class _SubAppBar extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const _SubAppBar({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      isHome: false,
      titleText: title,
      actions: [
        IconBtn(onTap: onTap, iconPath: 'assets/images/icons/ic_Etc.svg'),
      ],
    );
  }
}

// 뒤로가기 + 타이틀 + 알림버튼
class _SubNotifyAppBar extends ConsumerWidget {
  final String title;
  const _SubNotifyAppBar({required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNew = ref.watch(notificationProvider);
    return CustomAppBar(
      isHome: false,
      titleText: title,
      actions: [
        IconBtn(
          iconPath: isNew
              ? 'assets/images/icons/ic_status=new.svg'
              : 'assets/images/icons/ic_status=normal.svg',
          onTap: () {
            context.push(AppPaths.notify);
          },
        ),
      ],
    );
  }
}

// 뒤로가기 + 타이틀 + 알림버튼
class _NotifyAppBar extends ConsumerWidget {
  final String title;
  const _NotifyAppBar({required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNew = ref.watch(notificationProvider);
    return CustomAppBar(
      isHome: false,
      titleText: title,
      leading: CustomBackBtn(),
      actions: [
        IconBtn(
          iconPath: isNew
              ? 'assets/images/icons/ic_status=new.svg'
              : 'assets/images/icons/ic_status=normal.svg',
          onTap: () {
            context.push(AppPaths.notify);
          },
        ),
      ],
    );
  }
}

class _AddPostAppBar extends ConsumerWidget {
  final String title;
  final bool isFirst;
  final bool isSearch;

  const _AddPostAppBar({
    required this.title,
    this.isFirst = false,
    this.isSearch = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void handleClose(BuildContext context) async {
      final addPostState = ref.read(addPostProvider);

      if (!addPostState.hasAnyInput) {
        // 입력한 게 아무것도 없으면 확인창 없이 바로 나가기
        context.go(AppPaths.home);
        return;
      }

      final result = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('작성을 그만 두시겠어요?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'discard'),
              child: Text('저장안함'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'save'),
              child: Text('계속진행'),
            ),
          ],
        ),
      );

      if (result == 'discard') {
        ref.read(addPostProvider.notifier).reset();
        if (context.mounted) context.go(AppPaths.home);
      }

      // // 입력한 게 있으면 확인 다이얼로그
      // final result = await showDialog<String>(
      //   context: context,
      //   builder: (context) => AlertDialog(
      //     title: Text('작성을 그만두시겠어요?'),
      //     content: Text('지금까지 작성한 내용을 임시저장할 수 있어요.'),
      //     actions: [
      //       TextButton(
      //         onPressed: () => Navigator.pop(context, 'discard'),
      //         child: Text('저장 안 함'),
      //       ),
      //       TextButton(
      //         onPressed: () => Navigator.pop(context, 'save'),
      //         child: Text('임시저장'),
      //       ),
      //     ],
      //   ),
      // );
      //
      // if (result == 'save') {
      //   // 임시저장 로직 (예: SharedPreferences, 로컬 DB 등에 저장)
      //   // saveDraft(addPostState);
      //   ref.read(addPostProvider.notifier).reset(); // Provider는 초기화
      //   if (context.mounted) context.go('/home');
      // } else if (result == 'discard') {
      //   ref.read(addPostProvider.notifier).reset(); // 그냥 지우고 초기화
      //   if (context.mounted) context.go('/home');
      // }
      // // result == null (다이얼로그 바깥 탭) → 아무것도 안 함
    }

    return CustomAppBar(
      isHome: false,
      titleText: title,
      leading: isFirst ? null : CustomBackBtn(),
      actions: isSearch
          ? []
          : [
              GestureDetector(
                onTap: () => handleClose(context),
                child: Text('닫기', style: AppFonts.b1nSB),
                // child: Container(
                //   height: 28,
                //   alignment: Alignment.center,
                //   padding: EdgeInsets.symmetric(horizontal: 8),
                //   decoration: BoxDecoration(
                //     color: AppColors.point95,
                //     borderRadius: BorderRadius.circular(8),
                //   ),
                //   child: Text(
                //     '닫기',
                //     style: AppFonts.b1nSB.copyWith(color: AppColors.point50),
                //   ),
                // ),
              ),
            ],
    );
  }
}
