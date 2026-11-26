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

  /// true일 때 [text]를 이미지 URL로 처리 (IMAGE, EMOTICON 메시지)
  final bool isImage;

  /// 상대 미확인 내 메시지 여부 (말풍선 옆 '1' 표시)
  final bool showUnread;

  const ChatBubble({
    super.key,
    this.isMe = false,
    this.showAvatar = false,
    this.avatarImg,
    this.isImage = false,
    this.showUnread = false,
    required this.text,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 0.6;

    final Widget bubble = isImage
        ? ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              text,
              width: maxWidth,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) => progress == null
                  ? child
                  : SizedBox(
                      width: maxWidth,
                      height: maxWidth * 0.75,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
              errorBuilder: (_, _, _) => Container(
                width: maxWidth,
                height: maxWidth * 0.75,
                color: AppColors.neutral99,
                alignment: Alignment.center,
                child: Text(
                  '이미지를 불러올 수 없어요',
                  style: AppFonts.c1R.copyWith(color: AppColors.neutral60),
                ),
              ),
            ),
          )
        : Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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

    final timeText = Column(
      crossAxisAlignment: isMe
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        if (showUnread)
          Text('1', style: AppFonts.c2R.copyWith(color: AppColors.point50)),
        Text(time, style: AppFonts.c2R.copyWith(color: AppColors.neutral60)),
      ],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        spacing: 4,
        children: [
          if (!isMe)
            showAvatar
                ? AvatarBox(avatarImg: avatarImg, isSmall: true)
                : const SizedBox(width: 32, height: 32),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: 4,
              children: isMe
                  ? [timeText, Flexible(child: bubble)]
                  : [Flexible(child: bubble), timeText],
            ),
          ),
        ],
      ),
    );
  }
}
