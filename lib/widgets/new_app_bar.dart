import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jiburo_app/styles/colors.dart';
import 'package:jiburo_app/styles/fonts.dart';

enum AppBarStatus { notify, map, info }

class NewAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isHome;
  final Widget? icRight;
  final String? titleText;
  final void Function()? onBackTap;
  final void Function()? onTap;

  const NewAppBar({
    super.key,
    required this.isHome,
    this.titleText,
    this.onBackTap,
    this.onTap,
    this.icRight,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      title: Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: onBackTap,
              child: SizedBox(
                width: 24,
                child: isHome
                    ? null
                    : SvgPicture.asset('assets/images/icons/ic_Left-Arrow.svg'),
              ),
            ),

            isHome
                ? SvgPicture.asset("assets/images/logos/Jiburo-text-logo.svg")
                : Text(titleText!, style: AppFonts.hd2SB),

            GestureDetector(
              onTap: onTap,
              child: SizedBox(width: 24, child: icRight),
            ),
          ],
        ),
      ),
    );
  }
}
