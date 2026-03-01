import 'package:flutter/material.dart';
import 'package:jiburo_app/widgets/empty_widget.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyWidget(
      text: '아직은 대화 기록이 없어요',
      imgPath: 'assets/images/message.png',
    );
  }
}
