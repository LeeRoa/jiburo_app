import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiburo_app/core/routes/app_paths.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';
import 'package:jiburo_app/core/utils/formatters.dart';
import 'package:jiburo_app/core/utils/unfocus_input.dart';
import 'package:jiburo_app/core/views/widgets/app-bar/index_app_bar.dart';
import 'package:jiburo_app/core/views/widgets/plain_layout.dart';
import 'package:jiburo_app/features/chat/dto/chat_dtos.dart';
import 'package:jiburo_app/features/chat/providers/chat_providers.dart';
import 'package:jiburo_app/features/chat/views/widget/chat_bubble.dart';
import 'package:jiburo_app/features/chat/views/widget/chat_input_bar.dart';
import 'package:jiburo_app/features/lost_post/services/image_compress_service.dart';

class MessageDetailScreen extends ConsumerStatefulWidget {
  final String id;
  const MessageDetailScreen({super.key, required this.id});

  @override
  ConsumerState<MessageDetailScreen> createState() =>
      _MessageDetailScreenState();
}

class _MessageDetailScreenState extends ConsumerState<MessageDetailScreen> {
  final ScrollController _scroll = ScrollController();
  int _lastCount = 0;

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  bool _onSend(String text) {
    final ok = ref.read(chatRoomProvider(widget.id).notifier).sendText(text);
    if (!ok) _toast('서버에 연결 중이에요. 잠시 후 다시 보내주세요');
    return ok;
  }

  Future<void> _onPickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    try {
      final compressed = await ImageCompressService.compressForDetail(
        picked.path,
      );
      final ok = await ref
          .read(chatRoomProvider(widget.id).notifier)
          .sendImage(compressed ?? File(picked.path));
      if (!ok) _toast('서버에 연결 중이에요. 잠시 후 다시 보내주세요');
    } catch (_) {
      _toast('사진을 보내지 못했어요');
    }
  }

  @override
  Widget build(BuildContext context) {
    final room = ref.watch(chatRoomProvider(widget.id));
    final myId = ref.watch(myUserIdProvider);
    final nickname = ref
        .watch(chatRoomsProvider)
        .valueOrNull
        ?.where((r) => r.roomId == widget.id)
        .firstOrNull
        ?.otherUserNickname;

    // 새 메시지 수신 시 하단 스크롤
    final count = room.valueOrNull?.messages.length ?? 0;
    if (count != _lastCount) {
      _lastCount = count;
      _scrollToBottom();
    }

    return GestureDetector(
      onTap: () => unfocusInput(context),
      child: PlainLayout(
        appBar: IndexAppBar(
          type: AppBarType.detail,
          title: nickname ?? '채팅',
          onMenu: () {},
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
          child: Column(
            children: [
              if (room.valueOrNull != null)
                _PostHeader(detail: room.requireValue.detail),
              Expanded(
                child: room.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 8,
                      children: [
                        Text(
                          '대화를 불러오지 못했어요',
                          style: AppFonts.b1nM.copyWith(
                            color: AppColors.neutral60,
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              ref.invalidate(chatRoomProvider(widget.id)),
                          child: const Text('다시 시도'),
                        ),
                      ],
                    ),
                  ),
                  data: (state) => _MessageList(
                    messages: state.messages,
                    myId: myId,
                    controller: _scroll,
                  ),
                ),
              ),
              ChatInputBar(onSend: _onSend, onPickImage: _onPickImage),
            ],
          ),
        ),
      ),
    );
  }
}

/// 연결 게시글 요약 (탭 시 게시글 이동, 삭제된 게시글은 안내 문구만 표시)
class _PostHeader extends StatelessWidget {
  final ChatRoomDetail detail;
  const _PostHeader({required this.detail});

  @override
  Widget build(BuildContext context) {
    final deleted = detail.postDeleted;
    return GestureDetector(
      onTap: deleted
          ? null
          : () => context.push(AppPaths.postDetail(detail.postId)),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.neutral99,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          deleted ? '삭제된 게시글이에요' : detail.postTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppFonts.b2nM.copyWith(
            color: deleted ? AppColors.neutral60 : AppColors.neutral20,
          ),
        ),
      ),
    );
  }
}

class _MessageList extends StatelessWidget {
  final List<ChatMessage> messages;
  final String? myId;
  final ScrollController controller;
  const _MessageList({
    required this.messages,
    required this.myId,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return Center(
        child: Text(
          '첫 메시지를 보내 보세요',
          style: AppFonts.b1nM.copyWith(color: AppColors.neutral60),
        ),
      );
    }

    return ListView.builder(
      controller: controller,
      itemCount: messages.length,
      itemBuilder: (context, i) {
        final m = messages[i];
        final prev = i > 0 ? messages[i - 1] : null;
        final isMe = m.senderId == myId;
        final newDay =
            m.createdAt != null &&
            (prev?.createdAt == null || !_sameDay(prev!.createdAt!, m.createdAt!));
        // 연속 발신 시 첫 메시지에만 아바타 표시
        final showAvatar = !isMe && (prev == null || prev.senderId != m.senderId || newDay);

        if (m.isSystem) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Center(
              child: Text(
                m.content,
                style: AppFonts.c1R.copyWith(color: AppColors.neutral60),
              ),
            ),
          );
        }

        return Column(
          children: [
            if (newDay)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  formatChatDate(m.createdAt!),
                  style: AppFonts.c2R.copyWith(color: AppColors.neutral60),
                ),
              ),
            ChatBubble(
              isMe: isMe,
              showAvatar: showAvatar,
              isImage: m.isImage,
              showUnread: isMe && m.unreadCount > 0,
              text: m.content,
              time: formatChatTime(m.createdAt),
            ),
          ],
        );
      },
    );
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
