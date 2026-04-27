import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jiburo_app/styles/colors.dart';

class CustomBackBtn extends StatelessWidget {
  const CustomBackBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: BackButton(
        onPressed: () {
          context.pop();
        },
        color: AppColors.neutral30,
        style: ButtonStyle(padding: WidgetStateProperty.all(EdgeInsets.zero)),
      ),
    );
  }
}
