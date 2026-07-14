import 'package:flutter/material.dart';
import 'package:jiburo_app/core/views/widgets/input/input_text_widget.dart';
import 'package:jiburo_app/core/views/widgets/label_text.dart';

class InputWithLabel extends StatelessWidget {
  final String placeHolder;
  final String label;
  final bool isImport;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final TextInputAction? inputAction;
  final TextInputType? inputType;
  final bool? readOnly;
  final String? errorText;
  const InputWithLabel({
    super.key,
    required this.placeHolder,
    required this.label,
    required this.controller,
    this.onChanged,
    this.isImport = false,
    this.focusNode,
    this.inputAction,
    this.inputType,
    this.readOnly = false,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      children: [
        LabelText(label: label, isImport: isImport),
        InputTextWidget(
          placeHolder: placeHolder,
          controller: controller,
          onChanged: onChanged,
          focusNode: focusNode,
          inputAction: inputAction,
          inputType: inputType,
          readOnly: readOnly,
          errorText: errorText,
        ),
      ],
    );
  }
}
