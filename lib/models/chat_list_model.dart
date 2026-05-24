class ChatListModel {
  final String id;
  final String nickName;
  final String? avatar;
  final String latestChat;
  final String missingSpot;
  final String time;
  final String chatCnt;
  final bool isRead;

  ChatListModel({
    required this.id,
    required this.nickName,
    this.avatar,
    required this.latestChat,
    required this.missingSpot,
    required this.time,
    required this.chatCnt,
    required this.isRead,
  });
}
