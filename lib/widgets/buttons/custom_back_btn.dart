import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jiburo_app/styles/colors.dart';

class CustomBackBtn extends StatelessWidget {
  final String backPath;
  const CustomBackBtn({super.key, required this.backPath});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: BackButton(
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(backPath);
          }
        },
        color: AppColors.neutral30,
        style: ButtonStyle(padding: WidgetStateProperty.all(EdgeInsets.zero)),
      ),
    );
  }
}
