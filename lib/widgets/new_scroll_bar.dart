import 'package:flutter/material.dart';

class NewScrollBar extends StatelessWidget {
  final Widget child;
  const NewScrollBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 15),
      thickness: 3,
      radius: const Radius.circular(10),
      child: child,
    );
  }
}
