import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';
import 'package:jiburo_app/core/views/widgets/buttons/icon_btn.dart';

class InputTextWidget extends StatefulWidget {
  final String placeHolder;
  final bool isChat;
  final bool isText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final TextInputAction? inputAction;
  final TextInputType? inputType;
  final bool? readOnly;
  final bool showClearButton;
  final String? errorText;
  const InputTextWidget({
    super.key,
    required this.placeHolder,
    this.isChat = false,
    this.isText = false,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.inputAction,
    this.inputType,
    this.readOnly = false,
    this.showClearButton = false,
    this.errorText,
  });

  @override
  State<InputTextWidget> createState() => _InputTextWidgetState();
}

class _InputTextWidgetState extends State<InputTextWidget> {
  late final FocusNode focusNode = widget.focusNode ?? FocusNode();
  late final TextEditingController controller =
      widget.controller ?? TextEditingController();
  bool get isTexting => widget.isChat || widget.isText;

  void _onTextChanged() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    controller.removeListener(_onTextChanged);
    // 외부에서 넘겨준 게 아닌 경우 내가 만든 거면 내가 정리
    if (widget.focusNode == null) focusNode.dispose();
    if (widget.controller == null) controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasText = controller.text.isNotEmpty;

    return Stack(
      children: [
        TextFormField(
          focusNode: focusNode,
          readOnly: widget.readOnly!,
          controller: controller,
          onChanged: widget.onChanged,
          minLines: widget.isText ? null : 1,
          maxLines: widget.isText
              ? null
              : widget.isChat
              ? 5
              : 1,
          expands: widget.isText ? true : false,
          keyboardType:
              widget.inputType ??
              (isTexting ? TextInputType.multiline : TextInputType.text),
          textInputAction:
              widget.inputAction ??
              (isTexting
                  // 줄바꿈
                  ? TextInputAction.newline
                  : TextInputAction.done),
          textAlignVertical: isTexting
              ? TextAlignVertical.top
              : null, // 시작줄 맨 위
          scrollPadding: EdgeInsets.only(bottom: 80),
          inputFormatters: widget.inputType == TextInputType.number
              ? [FilteringTextInputFormatter.digitsOnly]
              : [],
          decoration: InputDecoration(
            filled: true, // 내부 컬러 설정
            fillColor: AppColors.white,
            hintText: widget.placeHolder,
            hintStyle: AppFonts.b2nM.copyWith(color: AppColors.neutral90),
            errorText: widget.errorText,
            errorStyle: AppFonts.c1R.copyWith(color: AppColors.errorRed),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.errorRed),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.neutral90),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.neutral90),
            ),
            contentPadding: EdgeInsets.only(
              top: 12,
              bottom: 12,
              left: 16,
              right: 50, // 아이콘 자리만큼 오른쪽 여백 확보 (텍스트가 아이콘과 안 겹치게)
            ),
          ),
        ),

        if ((widget.isChat || hasText) && widget.showClearButton)
          Positioned(
            right: 16,
            bottom: 16,
            child: IconBtn(
              width: 22,
              height: 22,
              iconPath:
                  'assets/images/icons/${widget.isChat ? 'ic_Emoji' : 'ic_Cancel'}.svg',
              onTap: () => controller.clear(),
            ),
          ),
      ],
    );
  }
}
