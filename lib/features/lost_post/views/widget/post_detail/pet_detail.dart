import 'package:flutter/material.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';

class PetDetail extends StatelessWidget {
  final String title;
  final String value;
  const PetDetail({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$title : ', style: AppFonts.l1nSB),
        Text(value, style: AppFonts.l1nM),
      ],
    );
  }
}
