import 'package:flutter/material.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';
import 'package:jiburo_app/features/chat/views/widget/avatar_box.dart';
import 'package:jiburo_app/models/chat_list_model.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';

class ChatRoomCard extends StatelessWidget {
  final ChatListModel chat;
  final Function() onMove;
  const ChatRoomCard({super.key, required this.chat, required this.onMove});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onMove,
      child: Container(
        width: double.infinity,
        padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          spacing: 4,
          children: [
            AvatarBox(avatarImg: chat.avatar),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    spacing: 4,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(chat.nickName, style: AppFonts.b1nSB),
                      Text(
                        '${chat.missingSpot} · ${chat.time}',
                        style: AppFonts.c1R.copyWith(
                          color: AppColors.neutral60,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    spacing: 4,
                    children: [
                      Expanded(
                        child: Text(
                          chat.latestChat,
                          style: AppFonts.c1M.copyWith(
                            color: AppColors.neutral60,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!chat.isRead)
                        Container(
                          width: 16,
                          height: 16,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: AppColors.point50,
                          ),
                          child: Text(
                            chat.chatCnt,
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
