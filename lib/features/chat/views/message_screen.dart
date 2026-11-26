import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jiburo_app/core/routes/app_paths.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';
import 'package:jiburo_app/core/views/widgets/app-bar/index_app_bar.dart';
import 'package:jiburo_app/core/views/widgets/empty_widget.dart';
import 'package:jiburo_app/core/views/widgets/plain_layout.dart';
import 'package:jiburo_app/core/views/widgets/tabs/tab_widget.dart';
import 'package:jiburo_app/features/auth/providers/auth_provider.dart';
import 'package:jiburo_app/features/chat/providers/chat_providers.dart';

import 'widget/chat_room_card.dart';

class MessageScreen extends ConsumerStatefulWidget {
  const MessageScreen({super.key});

  @override
  ConsumerState<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends ConsumerState<MessageScreen> {
  bool _isUnread = false;

  void _onTapTabBtn(bool isUnread) {
    setState(() => _isUnread = isUnread);
  }

  Future<void> _refresh() async {
    ref.invalidate(chatRoomsProvider);
    await ref.read(chatRoomsProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final isLogin = ref.watch(authProvider).isLogin;
    final rooms = ref.watch(chatRoomsProvider);

    return PlainLayout(
      appBar: IndexAppBar(type: AppBarType.sub, title: '메세지', onMenu: () {}),
      body: !isLogin
          ? const EmptyWidget(
              text: '로그인하면 대화 기록을 볼 수 있어요',
              imgPath: 'assets/images/message.png',
              btnText: '홈으로 이동',
            )
          : rooms.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8,
                  children: [
                    Text(
                      '대화 목록을 불러오지 못했어요',
                      style: AppFonts.b1nM.copyWith(color: AppColors.neutral60),
                    ),
                    TextButton(
                      onPressed: () => ref.invalidate(chatRoomsProvider),
                      child: const Text('다시 시도'),
                    ),
                  ],
                ),
              ),
              data: (all) {
                if (all.isEmpty) {
                  return const EmptyWidget(
                    text: '아직은 대화 기록이 없어요',
                    imgPath: 'assets/images/message.png',
                    btnText: '홈으로 이동',
                  );
                }
                final chats = _isUnread
                    ? all.where((c) => c.unreadCount > 0).toList()
                    : all;
                return Column(
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
                      child: RefreshIndicator(
                        onRefresh: _refresh,
                        child: chats.isEmpty
                            ? ListView(
                                children: [
                                  const SizedBox(height: 120),
                                  Center(
                                    child: Text(
                                      '안 읽은 대화가 없어요',
                                      style: AppFonts.b1nM.copyWith(
                                        color: AppColors.neutral60,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : ListView.separated(
                                itemCount: chats.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(height: 8),
                                itemBuilder: (context, index) {
                                  final chat = chats[index];
                                  return ChatRoomCard(
                                    chat: chat,
                                    onMove: () async {
                                      await context.push(
                                        AppPaths.messageDetail(chat.roomId),
                                      );
                                      // 복귀 시 안읽음 수·마지막 메시지 갱신
                                      ref.invalidate(chatRoomsProvider);
                                    },
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
