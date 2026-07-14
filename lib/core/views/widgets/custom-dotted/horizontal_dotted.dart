import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HorizontalDotted extends StatelessWidget {
  const HorizontalDotted({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 54,
      child: SvgPicture.asset('assets/images/dotted.svg'),
    );
  }
}
