import 'package:flutter/material.dart';
import 'package:jiburo_app/styles/colors.dart';
import 'package:jiburo_app/styles/fonts.dart';
import 'package:jiburo_app/widgets/buttons/icon_btn.dart';

class InputTextWidget extends StatefulWidget {
  final String placeHolder;
  const InputTextWidget({super.key, required this.placeHolder});

  @override
  State<InputTextWidget> createState() => _InputTextWidgetState();
}

class _InputTextWidgetState extends State<InputTextWidget> {
  final FocusNode focusNode = FocusNode();
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() {
        isFocused = focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    // 메모리 해제
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        focusNode: focusNode,
        decoration: InputDecoration(
          hintText: widget.placeHolder,
          hintStyle: AppFonts.b2nM.copyWith(color: AppColors.neutral90),
          suffixIconConstraints: BoxConstraints(minWidth: 22, minHeight: 22),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconBtn(
              iconPath: 'assets/images/icons/ic_Cancel.svg',
              onTap: () {},
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.neutral20),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.neutral20),
          ),
          contentPadding: EdgeInsetsGeometry.symmetric(
            horizontal: 16,
            vertical: 13,
          ),
        ),
      ),
    );
  }
}
