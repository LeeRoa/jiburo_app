import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiburo_app/core/views/widgets/input/input_text_widget.dart';

class ChatInputBar extends StatefulWidget {
  /// 전송 버튼 콜백 (true 반환 시 입력창 초기화)
  final bool Function(String text) onSend;

  /// 사진 선택 버튼 콜백
  final VoidCallback? onPickImage;

  const ChatInputBar({super.key, required this.onSend, this.onPickImage});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController controller = TextEditingController();
  bool hasText = false;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      final next = controller.text.trim().isNotEmpty;
      if (next != hasText) setState(() => hasText = next);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = controller.text;
    if (text.trim().isEmpty) return;
    if (widget.onSend(text)) controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onPickImage,
            child: Container(
              alignment: Alignment.center,
              width: 48,
              height: 48,
              child: SvgPicture.asset("assets/images/icons/ic_add-img.svg"),
            ),
          ),
          Expanded(
            child: InputTextWidget(
              controller: controller,
              placeHolder: '텍스트를 입력해 주세요.',
              isChat: true,
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _send,
            child: Container(
              alignment: Alignment.center,
              width: 48,
              height: 48,
              child: SvgPicture.asset(
                'assets/images/icons/${hasText ? "ic_send=active" : "ic_send"}.svg',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
