import 'package:flutter/material.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';

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
Future<bool?> showLeaveRoomDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: AppColors.white,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '채팅방 나가기를 선택하시면 해당 채팅방 목록 및 대화 내용이 삭제되고 복구할 수 없어요.',
              style: AppFonts.b2nM,
            ),
            const SizedBox(height: 20),
            Row(
              spacing: 8,
              children: [
                Expanded(
                  child: _DialogButton(
                    label: '취소',
                    background: AppColors.neutral95,
                    foreground: AppColors.black,
                    onTap: () => Navigator.of(context).pop(false),
                  ),
                ),
                Expanded(
                  child: _DialogButton(
                    label: '예, 나갈래요',
                    background: AppColors.point50,
                    foreground: AppColors.white,
                    onTap: () => Navigator.of(context).pop(true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class _DialogButton extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;
  const _DialogButton({
    required this.label,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          height: 44,
          alignment: Alignment.center,
          child: Text(label, style: AppFonts.b2nSB.copyWith(color: foreground)),
        ),
      ),
    );
  }
}
