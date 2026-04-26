import 'package:flutter/material.dart';
import 'package:jiburo_app/routes/app_paths.dart';
import 'package:jiburo_app/styles/colors.dart';
import 'package:jiburo_app/styles/fonts.dart';
import 'package:jiburo_app/widgets/buttons/custom_back_btn.dart';
import 'package:jiburo_app/widgets/buttons/icon_btn.dart';
import 'package:jiburo_app/widgets/new_app_bar.dart';

class DemoModel {
  final String content;
  final bool isNew;
  final bool hasImg;

  DemoModel({required this.content, required this.isNew, this.hasImg = false});
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    final List<DemoModel> items = [
      DemoModel(
        content: "알림의 내용이 들어갑니다. 내용이 길어지면 다음 줄로 넘어가요.",
        isNew: true,
        hasImg: false,
      ),
      DemoModel(
        content: "알림의 내용이 들어갑니다. 내용이 길어지면 다음 줄로 넘어가요.",
        isNew: true,
        hasImg: true,
      ),
      DemoModel(
        content: "알림의 내용이 들어갑니다. 내용이 길어지면 다음 줄로 넘어가요.",
        isNew: true,
        hasImg: false,
      ),
      DemoModel(
        content: "알림의 내용이 들어갑니다. 내용이 길어지면 다음 줄로 넘어가요.",
        isNew: true,
        hasImg: true,
      ),
      DemoModel(
        content: "알림의 내용이 들어갑니다. 내용이 길어지면 다음 줄로 넘어가요.",
        isNew: true,
        hasImg: true,
      ),
      DemoModel(
        content: "알림의 내용이 들어갑니다. 내용이 길어지면 다음 줄로 넘어가요.",
        isNew: true,
        hasImg: false,
      ),
      DemoModel(
        content: "알림의 내용이 들어갑니다. 내용이 길어지면 다음 줄로 넘어가요.",
        isNew: true,
        hasImg: false,
      ),
      DemoModel(
        content: "알림의 내용이 들어갑니다. 내용이 길어지면 다음 줄로 넘어가요.",
        isNew: true,
        hasImg: false,
      ),
      DemoModel(
        content: "알림의 내용이 들어갑니다. 내용이 길어지면 다음 줄로 넘어가요.",
        isNew: true,
        hasImg: false,
      ),
      DemoModel(
        content: "알림의 내용이 들어갑니다. 내용이 길어지면 다음 줄로 넘어가요.",
        isNew: true,
        hasImg: false,
      ),
      DemoModel(
        content: "알림의 내용이 들어갑니다. 내용이 길어지면 다음 줄로 넘어가요.",
        isNew: true,
        hasImg: false,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: NewAppBar(
        isHome: false,
        titleText: '알림',
        leading: CustomBackBtn(backPath: AppPaths.home),
        actions: [
          IconBtn(onTap: () {}, iconPath: 'assets/images/icons/ic_Etc.svg'),
        ],
      ),
      body: RawScrollbar(
        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 15),
        thickness: 3,
        radius: const Radius.circular(10),
        child: Container(
          decoration: BoxDecoration(color: AppColors.white),
          padding: EdgeInsets.only(top: 8),
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return _buildItems(items[index]);
            },
          ),
        ),
      ),
    );
  }
}

Widget _buildItems(DemoModel item) {
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
            Text('캡션', style: AppFonts.c1SB.copyWith(color: AppColors.point50)),
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
                    item.content,
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

            if (item.hasImg)
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
