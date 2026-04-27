import 'package:flutter/material.dart';
import 'package:jiburo_app/styles/colors.dart';
import 'package:jiburo_app/widgets/app-bar/index_app_bar.dart';
import 'package:jiburo_app/screens/home/widget/notify_card.dart';
import 'package:jiburo_app/widgets/new_scroll_bar.dart';
import 'package:jiburo_app/widgets/plain_layout.dart';

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

    return PlainLayout(
      appBar: IndexAppBar(type: AppBarType.detail, title: '알림', onMenu: () {}),
      body: NewScrollBar(
        child: Container(
          decoration: BoxDecoration(color: AppColors.white),
          padding: EdgeInsets.only(top: 8),
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return NotifyCard(item: items[index]);
            },
          ),
        ),
      ),
    );
  }
}
