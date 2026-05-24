import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiburo_app/styles/colors.dart';
import 'package:jiburo_app/styles/fonts.dart';

class AddStep extends StatefulWidget {
  const AddStep({super.key});

  @override
  State<AddStep> createState() => _AddStepState();
}

class _AddStepState extends State<AddStep> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 312,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          _buildStepLabel('1', '실종위치', true, true),
          _buildStepLabel('2', '실종정보', true, false),
          _buildStepLabel('3', '사진등록', false, false),
          _buildStepLabel('4', '추가내용', false, false),
        ],
      ),
    );
  }
}

Widget _buildStepLabel(String step, String label, bool isActive, bool isDone) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    spacing: 5,
    children: [
      Container(
        width: 24,
        height: 24,
        alignment: !isActive || isDone
            ? Alignment.center
            : Alignment.centerLeft,
        padding: !isActive || isDone ? null : EdgeInsets.only(left: 9),
        decoration: BoxDecoration(
          color: isActive ? AppColors.blue : AppColors.neutral95,
          borderRadius: BorderRadius.circular(70),
        ),
        child: !isDone
            ? Text(step, style: AppFonts.c1SB.copyWith(color: AppColors.white))
            : SvgPicture.asset('assets/images/check.svg'),
      ),
      Text(label, style: AppFonts.c1SB),
    ],
  );
}
