import 'package:flutter/material.dart';
import 'package:jiburo_app/styles/colors.dart';
import 'package:jiburo_app/styles/fonts.dart';

class DemoModel {
  final String content;
  final bool isNew;

  DemoModel({required this.content, required this.isNew});
}

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<DemoModel> items = [
      DemoModel(content: "알림의 내용이 들어갑니다. 내용이 길어지면 다음 줄로 넘어가요.", isNew: true),
      DemoModel(content: "알림의 내용이 들어갑니다. 내용이 길어지면 다음 줄로 넘어가요.", isNew: true),
      DemoModel(content: "알림의 내용이 들어갑니다. 내용이 길어지면 다음 줄로 넘어가요.", isNew: true),
      DemoModel(content: "알림의 내용이 들어갑니다. 내용이 길어지면 다음 줄로 넘어가요.", isNew: true),
      DemoModel(content: "알림의 내용이 들어갑니다. 내용이 길어지면 다음 줄로 넘어가요.", isNew: true),
      DemoModel(content: "알림의 내용이 들어갑니다. 내용이 길어지면 다음 줄로 넘어가요.", isNew: true),
      DemoModel(content: "알림의 내용이 들어갑니다. 내용이 길어지면 다음 줄로 넘어가요.", isNew: true),
      DemoModel(content: "알림의 내용이 들어갑니다. 내용이 길어지면 다음 줄로 넘어가요.", isNew: true),
      DemoModel(content: "알림의 내용이 들어갑니다. 내용이 길어지면 다음 줄로 넘어가요.", isNew: true),
      DemoModel(content: "알림의 내용이 들어갑니다. 내용이 길어지면 다음 줄로 넘어가요.", isNew: true),
    ];

    return Container(
      decoration: BoxDecoration(color: AppColors.white),
      padding: EdgeInsets.only(top: 8),
      child: ListView(
        children: [
          for (var item in items)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  Text(item.content, style: AppFonts.l1rM),
                  Text(
                    '날짜 또는 부가 정보',
                    style: AppFonts.c1R.copyWith(color: AppColors.neutral60),
                  ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    decoration: BoxDecoration(color: AppColors.neutral95),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
