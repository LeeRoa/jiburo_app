import 'package:flutter/material.dart';
import 'package:jiburo_app/styles/colors.dart';
import 'package:jiburo_app/styles/fonts.dart';

class TabWidget extends StatelessWidget {
  final bool firstIsActive;
  final String firstLabel;
  final void Function() firstOnTap;
  final bool secondIsActive;
  final String secondLabel;
  final void Function() secondOnTap;

  const TabWidget({
    super.key,
    required this.firstIsActive,
    required this.firstLabel,
    required this.firstOnTap,
    required this.secondIsActive,
    required this.secondLabel,
    required this.secondOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 16),
      child: Row(
        spacing: 8,
        children: [
          _tabBuild(firstIsActive, firstLabel, firstOnTap),
          _tabBuild(secondIsActive, secondLabel, secondOnTap),
        ],
      ),
    );
  }
}

Widget _tabBuild(bool isActive, String label, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? AppColors.neutral20 : AppColors.neutral99,
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Text(
        label,
        style: AppFonts.l1nSB.copyWith(
          color: isActive ? AppColors.white : AppColors.neutral20,
        ),
      ),
    ),
  );
}
