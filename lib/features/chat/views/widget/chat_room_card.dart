import 'package:flutter/material.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';
import 'package:jiburo_app/core/utils/formatters.dart';
import 'package:jiburo_app/features/chat/dto/chat_dtos.dart';
import 'package:jiburo_app/features/chat/views/widget/avatar_box.dart';

class ChatRoomCard extends StatelessWidget {
  final ChatRoom chat;
  final Function() onMove;
  const ChatRoomCard({super.key, required this.chat, required this.onMove});

  @override
  Widget build(BuildContext context) {
    final hasUnread = chat.unreadCount > 0;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onMove,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          spacing: 4,
          children: [
            const AvatarBox(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 4,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(chat.otherUserNickname, style: AppFonts.b1nSB),
                      Text(
                        formatRelativeTime(chat.lastChatAt),
                        style: AppFonts.c1R.copyWith(
                          color: AppColors.neutral60,
                        ),
                      ),
                    ],
                  ),
                  if (chat.postTitle.isNotEmpty)
                    Text(
                      chat.postTitle,
                      style: AppFonts.c1R.copyWith(color: AppColors.neutral60),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  Row(
                    spacing: 4,
                    children: [
                      Expanded(
                        child: Text(
                          chat.lastMessagePreview,
                          style: AppFonts.c1M.copyWith(
                            color: AppColors.neutral60,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hasUnread)
                        Container(
                          constraints: const BoxConstraints(minWidth: 16),
                          height: 16,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: AppColors.point50,
                          ),
                          child: Text(
                            chat.unreadCount > 99
                                ? '99+'
                                : '${chat.unreadCount}',
                            style: AppFonts.c2SB.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
