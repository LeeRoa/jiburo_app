import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jiburo_app/providers/notification_provider.dart';
import 'package:jiburo_app/routes/app_paths.dart';
import 'package:jiburo_app/widgets/app-bar/custom_app_bar.dart';
import 'package:jiburo_app/widgets/buttons/custom_back_btn.dart';
import 'package:jiburo_app/widgets/buttons/icon_btn.dart';

enum AppBarType { home, detail, sub, notify, subNotify }

class IndexAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBarType type;
  final String? title;
  final VoidCallback? onMenu;
  const IndexAppBar({super.key, required this.type, this.title, this.onMenu});

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      AppBarType.home => _HomeAppBar(),
      AppBarType.detail => _DetailAppBar(onTap: onMenu!, title: title!),
      AppBarType.sub => _SubAppBar(title: title!, onTap: onMenu!),
      AppBarType.notify => _NotifyAppBar(title: title!),
      AppBarType.subNotify => _SubNotifyAppBar(title: title!),
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
