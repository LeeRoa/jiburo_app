import 'package:flutter/material.dart';
import 'package:jiburo_app/widgets/empty_widget.dart';

class SavePage extends StatelessWidget {
  const SavePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyWidget(
      text: '찾아줄 친구를 저장해주세요',
      imgPath: 'assets/images/heart.png',
    );
  }
}
