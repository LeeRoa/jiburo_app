import 'package:flutter/material.dart';

class AnimatedBottom extends StatelessWidget {
  final bool isFocused;
  final Widget bottomWidget;
  const AnimatedBottom({
    super.key,
    required this.isFocused,
    required this.bottomWidget,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 120),
      child: isFocused
          ? bottomWidget
          : SizedBox.shrink(
              key: ValueKey(isFocused ? 'inline-hidden' : 'fixed-hidden'),
            ),
    );
  }
}
