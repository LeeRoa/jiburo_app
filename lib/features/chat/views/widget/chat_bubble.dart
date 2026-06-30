import 'package:flutter/material.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';
import 'package:jiburo_app/features/chat/views/widget/avatar_box.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final String time;
  final bool isMe;
  final bool showAvatar;
  final String? avatarImg;

  const ChatBubble({
    super.key,
    this.isMe = false,
    this.showAvatar = false,
    this.avatarImg,
    required this.text,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final bubble = Container(
      width: 218,
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isMe ? AppColors.point50 : AppColors.neutral99,
      ),
      child: Text(
        text,
        style: AppFonts.l1nR.copyWith(
          color: isMe ? AppColors.white : AppColors.neutral20,
        ),
      ),
    );

    final timeText = Text(
      time,
      style: AppFonts.c2R.copyWith(color: AppColors.neutral60),
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        spacing: 4,
        children: [
          isMe
              ? SizedBox.shrink() // 아예 없음
              : showAvatar
              ? AvatarBox(avatarImg: avatarImg, isSmall: true)
              : SizedBox(width: 32, height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 4,
            children: isMe ? [timeText, bubble] : [bubble, timeText],
          ),
        ],
      ),
    );
  }
}
