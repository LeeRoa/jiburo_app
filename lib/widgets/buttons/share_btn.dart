import 'package:flutter/material.dart';
import 'package:jiburo_app/widgets/buttons/main_btn.dart';

class ShareBtn extends StatelessWidget {
  final VoidCallback onTap;
  const ShareBtn({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return MainBtn(
      isIconOnly: true,
      btnName: '',
      onTap: onTap,
      variant: Variant.outlineDark,
      icLeft: 'assets/images/icons/ic_Share.svg',
    );
  }
}
