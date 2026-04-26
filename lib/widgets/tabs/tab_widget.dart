import 'package:flutter/material.dart';
import 'package:jiburo_app/styles/colors.dart';
import 'package:jiburo_app/styles/fonts.dart';

class TabWidget extends StatefulWidget {
  final bool isActive;
  final void Function() onTap;

  const TabWidget({super.key, required this.isActive, required this.onTap});

  @override
  State<TabWidget> createState() => _TabWidgetState();
}

class _TabWidgetState extends State<TabWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: widget.isActive ? AppColors.neutral20 : AppColors.neutral99,
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: Text(
          '거리순',
          style: AppFonts.l1nSB.copyWith(
            color: widget.isActive ? AppColors.white : AppColors.neutral20,
          ),
        ),
      ),
    );
  }
}
