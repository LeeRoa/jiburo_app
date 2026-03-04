import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jiburo_app/styles/colors.dart';
import 'package:jiburo_app/styles/fonts.dart';

enum AppBarStatus { notify, map, info }

class NewAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isHome;
  final String? titleText;
  final List<Widget>? actions;
  final Widget? leading;

  const NewAppBar({
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
      title: isHome
          ? SvgPicture.asset("assets/images/logos/Jiburo-text-logo.svg")
          : Text(titleText!, style: AppFonts.hd2SB),
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: leading,
      ),
      actionsPadding: EdgeInsets.only(right: 16),
      actions: actions,
    );
  }
}
