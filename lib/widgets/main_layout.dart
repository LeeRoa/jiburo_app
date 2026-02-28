import 'package:flutter/material.dart';
import 'package:jiburo_app/styles/colors.dart';
import 'package:jiburo_app/widgets/new_app_bar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: NewAppBar(isNew: true),
      body: child,
      // bottomNavigationBar: BottomNavigationBar(items: List.empty()),
    );
  }
}
