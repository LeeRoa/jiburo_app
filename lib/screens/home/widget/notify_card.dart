import 'package:flutter/material.dart';
import 'package:jiburo_app/screens/home/notification_page.dart';
import 'package:jiburo_app/styles/colors.dart';
import 'package:jiburo_app/styles/fonts.dart';

class NotifyCard extends StatefulWidget {
  final DemoModel item;
  const NotifyCard({super.key, required this.item});

  @override
  State<NotifyCard> createState() => _NotifyCardState();
}

class _NotifyCardState extends State<NotifyCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 8,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '캡션',
                style: AppFonts.c1SB.copyWith(color: AppColors.point50),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.point50,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // spacing: 16,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  SizedBox(
                    width: 218,
                    child: Text(
                      widget.item.content,
                      style: AppFonts.l1rM,
                      softWrap: true,
                    ),
                  ),
                  Text(
                    '날짜 또는 부가 정보',
                    style: AppFonts.c1R.copyWith(color: AppColors.neutral60),
                  ),
                ],
              ),

              if (widget.item.hasImg)
                Container(
                  width: 72,
                  height: 72,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Image.asset('assets/images/check.png'),
                ),
            ],
          ),
          SizedBox(height: 8),

          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 8),
            height: 1,
            decoration: BoxDecoration(color: AppColors.neutral95),
          ),
        ],
      ),
    );
  }
}
