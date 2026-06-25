import 'package:flutter/material.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';
import 'package:jiburo_app/core/views/widgets/buttons/icon_btn.dart';
import 'package:jiburo_app/core/views/widgets/input_text_widget.dart';
import 'package:jiburo_app/core/views/widgets/tabs/tab_widget.dart';

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
                  style: AppFonts.hd2B,
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
          TabWidget(
            firstLabel: '거리순',
            firstIsActive: true,
            firstOnTap: () {},
            secondLabel: '최신순',
            secondIsActive: false,
            secondOnTap: () {},
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
