import 'package:flutter/material.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';
import 'package:jiburo_app/core/views/widgets/app-bar/index_app_bar.dart';
import 'package:jiburo_app/core/views/widgets/pet-card/card_index.dart';
import 'package:jiburo_app/core/views/widgets/plain_layout.dart';
import 'package:jiburo_app/features/chat/views/widget/chat_bubble.dart';
import 'package:jiburo_app/features/chat/views/widget/chat_input_bar.dart';
import 'package:jiburo_app/models/find_pets_model.dart';

class MessageDetailScreen extends StatefulWidget {
  final String id;
  const MessageDetailScreen({super.key, required this.id});

  @override
  State<MessageDetailScreen> createState() => _MessageDetailScreenState();
}

class _MessageDetailScreenState extends State<MessageDetailScreen> {
  final FindPetsModel pet = FindPetsModel(
    id: "1",
    name: '복돌이',
    writer: '레이맘',
    title: "복돌이를 찾아주세요",
    breeds: '강아지',
    missingSpot: '서울시 강동구 천호동',
    area: '5',
    reward: '30',
    time: '1',
    imgPath: 'assets/images/1.jpg',
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // input 포커스 해제
        FocusScope.of(context).unfocus();
      },
      child: PlainLayout(
        appBar: IndexAppBar(
          type: AppBarType.detail,
          title: pet.writer,
          onMenu: () {},
        ),
        body: Container(
          padding: EdgeInsets.only(top: 8, left: 16, right: 16),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 155),
                      child: Column(
                        children: [
                          ChatBubble(
                            showAvatar: true,
                            text:
                                '텍스트 박스는 텍스트 길이에 따라 늘어납니다. 텍스트 박스는 텍스트 길이에 따라 늘어납니다.',
                            time: '오전 00:00',
                          ),
                          ChatBubble(
                            isMe: true,
                            text:
                                '텍스트 박스는 텍스트 길이에 따라 늘어납니다. 텍스트 박스는 텍스트 길이에 따라 늘어납니다.',
                            time: '오전 00:00',
                          ),
                        ],
                      ),

                      // Text(
                      //   '2025년 6월 12일',
                      //   style: AppFonts.c2R.copyWith(
                      //     color: AppColors.neutral60,
                      //   ),
                    ),
                  ),

                  ChatInputBar(),
                ],
              ),
              Positioned(child: CardIndex.small(pet: pet, hasLine: true)),
            ],
          ),
        ),
      ),
    );
  }
}
