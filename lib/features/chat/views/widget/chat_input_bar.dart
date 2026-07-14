import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiburo_app/core/views/widgets/input/input_text_widget.dart';

class ChatInputBar extends StatefulWidget {
  const ChatInputBar({super.key});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final FocusNode focusNode = FocusNode();
  final TextEditingController controller = TextEditingController();
  bool hasText = false;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        hasText = controller.text.isNotEmpty; // 텍스트 있으면 true
      });
    });
  }

  @override
  void dispose() {
    // 메모리 해제
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                alignment: Alignment.center,
                width: 48,
                height: 48,
                child: SvgPicture.asset("assets/images/icons/ic_add-img.svg"),
              ),
              Expanded(
                child: InputTextWidget(
                  controller: controller,
                  placeHolder: '텍스트를 입력해 주세요.',
                  isChat: true,
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: 48,
                height: 48,
                child: SvgPicture.asset(
                  'assets/images/icons/${hasText ? "ic_send=active" : "ic_send"}.svg',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
