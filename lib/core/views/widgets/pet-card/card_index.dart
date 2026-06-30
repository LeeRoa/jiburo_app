import 'package:flutter/material.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';
import 'package:jiburo_app/core/views/widgets/buttons/icon_btn.dart';
import 'package:jiburo_app/models/find_pets_model.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';

enum CardType { medium, small, find }

class CardIndex extends StatelessWidget {
  final FindPetsModel pet;
  final CardType type;
  final Function()? onSaveTab;
  final Function()? onMove;
  final Function()? onFind;
  final Function()? onMessage;
  final bool hasLine;

  const CardIndex.medium({
    super.key,
    required this.pet,
    required this.hasLine,
    required this.onSaveTab,
    required this.onMove,
  }) : type = CardType.medium,
       onFind = null,
       onMessage = null;

  const CardIndex.small({super.key, required this.pet, required this.hasLine})
    : type = CardType.small,
      onSaveTab = null,
      onMove = null,
      onFind = null,
      onMessage = null;

  const CardIndex.find({
    super.key,
    required this.pet,
    required this.hasLine,
    required this.onFind,
    required this.onMessage,
  }) : type = CardType.find,
       onSaveTab = null,
       onMove = null;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: type == CardType.medium ? onMove : null,
      child: Column(
        children: [
          Container(
            height: type == CardType.medium
                ? 185
                : type == CardType.small
                ? 120
                : 104,
            padding: type == CardType.find
                ? null
                : EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 16,
              children: [
                Container(
                  width: type == CardType.medium ? 169 : 104,
                  height: type == CardType.medium ? 169 : 104,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(pet.imgPath, fit: BoxFit.cover),
                ),

                // 실종카드
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(pet.title, style: AppFonts.b2nSB),
                            SizedBox(height: 4),
                            Text(pet.missingSpot, style: AppFonts.l2M),
                            Text(
                              "내 위치에서 ${pet.area}km 이내",
                              style: AppFonts.c2R,
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Text('사례금 : ', style: AppFonts.l2M),
                                Text(
                                  pet.reward,
                                  style: AppFonts.l2M.copyWith(
                                    color: AppColors.point50,
                                  ),
                                ),
                                Text(
                                  '만원',
                                  style: AppFonts.l2M.copyWith(
                                    color: AppColors.neutral60,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${pet.time}시간 전',
                            style: AppFonts.c2R.copyWith(
                              color: AppColors.neutral60,
                            ),
                          ),

                          if (CardType.medium == type)
                            IconBtn(
                              iconPath:
                                  'assets/images/icons/tab-bar/ic_Save${pet.isLike! ? '=Active' : ''}.svg',
                              onTap: onSaveTab!,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (hasLine)
            // 하단 구분선
            Container(
              width: double.infinity,
              height: 1,
              margin: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(color: AppColors.neutral95),
            ),
        ],
      ),
    );
  }
}
