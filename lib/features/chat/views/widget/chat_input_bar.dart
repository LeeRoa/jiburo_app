import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiburo_app/core/views/widgets/input_text_widget.dart';

class ChatInputBar extends StatefulWidget {
  const ChatInputBar({super.key});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                alignment: Alignment.center,
                width: 48,
                height: 48,
                child: SvgPicture.asset("assets/images/icons/ic_add-img.svg"),
              ),
              Expanded(
                child: InputTextWidget(
                  placeHolder: '텍스트를 입력해 주세요.',
                  onTap: () {},
                  isChat: true,
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: 48,
                height: 48,
                child: SvgPicture.asset("assets/images/icons/ic_send.svg"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
