import 'package:flutter/material.dart';

class AvatarBox extends StatelessWidget {
  final String? avatarImg;
  final bool isSmall;
  const AvatarBox({super.key, this.avatarImg, this.isSmall = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isSmall ? 32 : 48,
      height: isSmall ? 32 : 48,
      padding: EdgeInsets.all(isSmall ? 3.2 : 4.8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 1.2),
              blurRadius: 2.4,
              spreadRadius: 1.2,
              color: Color(0x1A000000),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.asset(
            avatarImg ?? 'assets/images/empty-img.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
