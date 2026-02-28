import 'package:flutter/material.dart';
import 'package:jiburo_app/styles/colors.dart';

class PlainLayout extends StatelessWidget {
  final Widget child;
  const PlainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.white, body: child);
  }
}
