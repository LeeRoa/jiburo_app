import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jiburo_app/styles/colors.dart';

class NewAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isNew;

  const NewAppBar({super.key, required this.isNew});

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
            SizedBox(width: 24),
            SvgPicture.asset("assets/images/logos/Jiburo-text-logo.svg"),
            SizedBox(
              width: 24,
              child: SvgPicture.asset(
                isNew
                    ? "assets/images/icons/ic_status=new.svg"
                    : "assets/images/icons/ic_status=normal.svg",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
