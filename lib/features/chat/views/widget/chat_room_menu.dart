import 'package:flutter/material.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';
import 'package:jiburo_app/core/views/widgets/dialogs/confirm_dialog.dart';

enum ChatRoomMenuAction { leave }

/// 앱바 ⋮ 버튼 아래에 뜨는 메뉴 (현재 항목: 채팅방 나가기)
Future<ChatRoomMenuAction?> showChatRoomMenu(BuildContext context) {
  final media = MediaQuery.of(context);
  return showMenu<ChatRoomMenuAction>(
    context: context,
    // 앱바(56) 바로 아래, 오른쪽 끝에 붙여서 표시
    position: RelativeRect.fromLTRB(
      media.size.width,
      media.padding.top + 56,
      16,
      0,
    ),
    color: AppColors.white,
    surfaceTintColor: Colors.transparent,
    elevation: 4,
    constraints: const BoxConstraints(minWidth: 148),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    items: [
      PopupMenuItem(
        value: ChatRoomMenuAction.leave,
        child: Text('채팅방 나가기', style: AppFonts.b2nM),
      ),
    ],
  );
}

/// 채팅방 나가기 확인창. 나가기를 선택하면 true
Future<bool?> showLeaveRoomDialog(BuildContext context) => showConfirmDialog(
  context,
  message: '채팅방 나가기를 선택하시면 해당 채팅방 목록 및 대화 내용이 삭제되고 복구할 수 없어요.',
  confirmLabel: '예, 나갈래요',
);
