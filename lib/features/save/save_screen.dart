import 'package:flutter/material.dart';
import 'package:jiburo_app/core/views/widgets/empty_widget.dart';

class SaveScreen extends StatelessWidget {
  const SaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyWidget(
      text: '찾아줄 친구를 저장해주세요',
      imgPath: 'assets/images/heart.png',
      btnText: '찾아주러 가기',
    );
  }
}
