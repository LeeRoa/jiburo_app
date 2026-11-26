// 채팅 도메인 DTO (서버 ChatRoomListDto, ChatMessageResponseDto, ChatRoomDetailDto, ChatReadDto 대응)

class ChatRoom {
  final String roomId;
  final String otherUserNickname;
  final String postTitle; // 게시글별 방 구분용 제목
  final String? lastMessage;
  final DateTime? lastChatAt;
  final int unreadCount;

  const ChatRoom({
    required this.roomId,
    required this.otherUserNickname,
    this.postTitle = '',
    this.lastMessage,
    this.lastChatAt,
    this.unreadCount = 0,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) => ChatRoom(
    roomId: json['roomId'] as String,
    otherUserNickname: json['otherUserNickname'] as String? ?? '',
    postTitle: json['postTitle'] as String? ?? '',
    lastMessage: json['lastMessage'] as String?,
    lastChatAt: _parseTime(json['lastChatAt']),
    unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
  );

  /// 마지막 메시지 미리보기 (서버 저장 표식 "[IMAGE]" 등을 안내 문구로 변환)
  String get lastMessagePreview => switch (lastMessage) {
    null || '' => '대화를 시작해 보세요',
    '[IMAGE]' => '사진을 보냈어요',
    '[VIDEO]' => '동영상을 보냈어요',
    '[EMOTICON]' => '이모티콘을 보냈어요',
    '[MAP]' => '위치를 보냈어요',
    '[SYS]' => '알림',
    final text => text,
  };
}

class ChatMessage {
  final String messageId;
  final String roomId;
  final String senderId;
  final String senderNickname;
  final String content;
  final String messageTypeCode; // TALK, IMAGE, VIDEO, MAP, EMOTICON, SYS
  final DateTime? createdAt;
  final int unreadCount;

  const ChatMessage({
    required this.messageId,
    required this.roomId,
    required this.senderId,
    required this.senderNickname,
    required this.content,
    required this.messageTypeCode,
    required this.createdAt,
    required this.unreadCount,
  });

  bool get isImage =>
      messageTypeCode == 'IMAGE' || messageTypeCode == 'EMOTICON';
  bool get isSystem => messageTypeCode == 'SYS';

  ChatMessage copyWith({int? unreadCount}) => ChatMessage(
    messageId: messageId,
    roomId: roomId,
    senderId: senderId,
    senderNickname: senderNickname,
    content: content,
    messageTypeCode: messageTypeCode,
    createdAt: createdAt,
    unreadCount: unreadCount ?? this.unreadCount,
  );

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    messageId: json['messageId'] as String,
    roomId: json['roomId'] as String,
    senderId: json['senderId'] as String? ?? '',
    senderNickname: json['senderNickname'] as String? ?? '',
    content: json['content'] as String? ?? '',
    messageTypeCode: json['messageTypeCode'] as String? ?? 'TALK',
    createdAt: _parseTime(json['createdAt']),
    unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
  );
}

class ChatRoomDetail {
  final String roomId;
  final String postId;
  final String postTitle;
  final String postStatusCode;
  final bool postDeleted;
  final List<ChatMessage> messages;
  final bool hasNext;

  const ChatRoomDetail({
    required this.roomId,
    required this.postId,
    required this.postTitle,
    required this.postStatusCode,
    required this.postDeleted,
    required this.messages,
    required this.hasNext,
  });

  factory ChatRoomDetail.fromJson(Map<String, dynamic> json) => ChatRoomDetail(
    roomId: json['roomId'] as String,
    postId: json['postId'] as String,
    postTitle: json['postTitle'] as String? ?? '',
    postStatusCode: json['postStatusCode'] as String? ?? '',
    postDeleted: json['postDeleted'] as bool? ?? false,
    messages: (json['messageHistory'] as List<dynamic>? ?? [])
        .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
        .toList(),
    hasNext: json['hasNext'] as bool? ?? false,
  );
}

/// 채팅방 상단 게시글 카드용 요약 (GET /posts/{id} 응답 일부)
class ChatPostSummary {
  final String id;
  final String title;
  final String foundLocation;
  final double? latitude;
  final double? longitude;
  final int? reward; // 단위: 만원
  final DateTime? createdAt;
  final String? imageUrl;

  const ChatPostSummary({
    required this.id,
    required this.title,
    required this.foundLocation,
    this.latitude,
    this.longitude,
    this.reward,
    this.createdAt,
    this.imageUrl,
  });

  factory ChatPostSummary.fromJson(Map<String, dynamic> json) =>
      ChatPostSummary(
        id: json['id'] as String,
        title: json['title'] as String? ?? '',
        foundLocation: json['foundLocation'] as String? ?? '',
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
        reward: (json['reward'] as num?)?.toInt(),
        createdAt: _parseTime(json['createdAt']),
        imageUrl: json['imageUrl'] as String?,
      );
}

/// 읽음 처리 브로드캐스트 (해당 메시지까지 읽음)
class ChatReadEvent {
  final String userId;
  final String lastReadMessageId;
  const ChatReadEvent({required this.userId, required this.lastReadMessageId});

  factory ChatReadEvent.fromJson(Map<String, dynamic> json) => ChatReadEvent(
    userId: json['userId'] as String,
    lastReadMessageId: json['lastReadMessageId'] as String,
  );
}

DateTime? _parseTime(Object? v) =>
    v == null ? null : DateTime.tryParse(v as String);
