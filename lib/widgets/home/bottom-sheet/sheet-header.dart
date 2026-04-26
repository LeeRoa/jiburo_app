import 'package:flutter/material.dart';
import 'package:jiburo_app/styles/colors.dart';
import 'package:jiburo_app/styles/fonts.dart';
import 'package:jiburo_app/widgets/buttons/icon_btn.dart';
import 'package:jiburo_app/widgets/input_text_widget.dart';
import 'package:jiburo_app/widgets/tabs/tab_widget.dart';

class SheetHeader extends StatefulWidget {
  final Function() onRefresh;
  final String name;

  const SheetHeader({super.key, required this.onRefresh, required this.name});

  @override
  State<SheetHeader> createState() => _SheetHeader();
}

class _SheetHeader extends State<SheetHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.white),
      child: Column(
        children: [
          Container(
            color: AppColors.white, // 배경색이 있어야 리스트가 뒤로 가려짐
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.name}님, 친구들을 찾아\n집으로 보내주세요',
                  style: AppFonts.hd2SB,
                ),
                IconBtn(
                  iconPath: 'assets/images/icons/ic_Refresh.svg',
                  onTap: widget.onRefresh,
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: InputTextWidget(placeHolder: '지역명/이름을 검색해보세요'),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsetsGeometry.symmetric(horizontal: 16),
            child: Row(
              spacing: 8,
              children: [
                TabWidget(isActive: true, onTap: () => {}),
                TabWidget(isActive: false, onTap: () => {}),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
