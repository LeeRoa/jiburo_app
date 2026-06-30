import 'package:flutter/material.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';

class PlainLayout extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  const PlainLayout({super.key, required this.body, this.appBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: appBar,
      body: SafeArea(child: body),
    );
  }
}
