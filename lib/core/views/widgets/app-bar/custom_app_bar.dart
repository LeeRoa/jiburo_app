import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';

enum AppBarStatus { notify, map, info }

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isHome;
  final String? titleText;
  final List<Widget>? actions;
  final Widget? leading;

  const CustomAppBar({
    super.key,
    required this.isHome,
    this.titleText,
    this.actions,
    this.leading,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      centerTitle: true,
      // 스크롤시 색상 변하지 않도록
      surfaceTintColor: Colors.transparent,
      title: isHome
          ? SvgPicture.asset("assets/images/logos/Jiburo-text-logo.svg")
          : Text(titleText!, style: AppFonts.hd2B),
      leadingWidth: 24 + 16,
      automaticallyImplyLeading: false,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: leading,
      ),
      actionsPadding: EdgeInsets.all(16),
      actions: actions,
    );
  }
}
