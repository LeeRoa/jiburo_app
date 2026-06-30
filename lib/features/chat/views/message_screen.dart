import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jiburo_app/core/routes/app_paths.dart';
import 'package:jiburo_app/core/views/widgets/app-bar/index_app_bar.dart';
import 'package:jiburo_app/core/views/widgets/empty_widget.dart';
import 'package:jiburo_app/core/views/widgets/plain_layout.dart';
import 'package:jiburo_app/core/views/widgets/tabs/tab_widget.dart';
import 'package:jiburo_app/models/chat_list_model.dart';

import 'widget/chat_room_card.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final bool isEmpty = false;
  List<ChatListModel> chats = [
    ChatListModel(
      id: '1',
      nickName: '레이맘',
      avatar: 'assets/images/6.jpg',
      latestChat: '어디서 보셨는지 알 수 있을까요? ㅠㅠ',
      missingSpot: '강동구',
      time: '1시간 전',
      chatCnt: '99',
      isRead: false,
    ),
    ChatListModel(
      id: '2',
      nickName: '멍집사',
      avatar: 'assets/images/1.jpg',
      latestChat: '공원에서 목격 했습니다',
      missingSpot: '강동구',
      time: '1시간 전',
      chatCnt: '',
      isRead: true,
    ),
    ChatListModel(
      id: '3',
      nickName: '별명',
      latestChat: '대화의 내용이 들어갑니다. 최대 길이는 한줄입니다. 최대길이는 한줄입니다.',
      missingSpot: '강동구',
      time: '1시간 전',
      chatCnt: '99',
      isRead: false,
    ),
  ];
  bool _isUnread = false;

  List<ChatListModel> get _filteredChats =>
      _isUnread ? chats.where((chat) => !chat.isRead).toList() : chats;

  void _onTapTabBtn(bool isUnread) {
    setState(() => _isUnread = isUnread);
  }

  @override
  Widget build(BuildContext context) {
    return PlainLayout(
      appBar: IndexAppBar(type: AppBarType.sub, title: '메세지', onMenu: () {}),
      body: isEmpty
          ? EmptyWidget(
              text: '아직은 대화 기록이 없어요',
              imgPath: 'assets/images/message.png',
              btnText: '홈으로 이동',
            )
          : Column(
              spacing: 8,
              children: [
                TabWidget(
                  firstLabel: '전체',
                  firstIsActive: !_isUnread,
                  firstOnTap: () => _onTapTabBtn(false),
                  secondLabel: '안읽음',
                  secondIsActive: _isUnread,
                  secondOnTap: () => _onTapTabBtn(true),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: _filteredChats.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      return ChatRoomCard(
                        chat: _filteredChats[index],
                        onMove: () {
                          context.push(
                            AppPaths.messageDetail(_filteredChats[index].id),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
