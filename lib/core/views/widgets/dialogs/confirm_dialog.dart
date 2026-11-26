import 'package:flutter/material.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';

/// 공용 확인창 ([취소] [확인]). 확인을 누르면 true
Future<bool?> showConfirmDialog(
  BuildContext context, {
  required String message,
  required String confirmLabel,
  String cancelLabel = '취소',
}) {
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
            Text(message, style: AppFonts.b2nM),
            const SizedBox(height: 20),
            Row(
              spacing: 8,
              children: [
                Expanded(
                  child: _DialogButton(
                    label: cancelLabel,
                    background: AppColors.neutral95,
                    foreground: AppColors.black,
                    onTap: () => Navigator.of(context).pop(false),
                  ),
                ),
                Expanded(
                  child: _DialogButton(
                    label: confirmLabel,
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
