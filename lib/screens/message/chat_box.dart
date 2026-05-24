import 'package:flutter/material.dart';
import 'package:jiburo_app/models/chat_list_model.dart';
import 'package:jiburo_app/styles/colors.dart';
import 'package:jiburo_app/styles/fonts.dart';

class ChatBox extends StatelessWidget {
  final ChatListModel chat;
  const ChatBox({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        spacing: 4,
        children: [
          Container(
            width: 48,
            height: 48,
            padding: EdgeInsets.all(4.8),
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
                  chat.avatar ?? 'assets/images/empty-img.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('제목', style: AppFonts.b1nSB),
                    Text(
                      '${chat.missingSpot} · ${chat.time}',
                      style: AppFonts.c1R.copyWith(color: AppColors.neutral60),
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
                          style: AppFonts.c2SB.copyWith(color: AppColors.white),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
