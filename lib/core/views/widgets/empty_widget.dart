import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';

import 'buttons/main_btn.dart';

class EmptyWidget extends StatelessWidget {
  final String text;
  final String imgPath;
  final String btnText;
  const EmptyWidget({
    super.key,
    required this.text,
    required this.imgPath,
    required this.btnText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 120),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(child: Image.asset(imgPath)),
          SizedBox(height: 12),
          Text(text, style: AppFonts.b1nM.copyWith(color: AppColors.neutral80)),
          SizedBox(height: 12),
          MainBtn(
            btnName: btnText,
            onTap: () {
              final shell = StatefulNavigationShell.of(context);
              shell.goBranch(0);
            },
            size: Size.small,
          ),
        ],
      ),
    );
  }
}
