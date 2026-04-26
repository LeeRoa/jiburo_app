import 'package:flutter/material.dart';
import 'package:jiburo_app/models/find_pets_model.dart';
import 'package:jiburo_app/styles/colors.dart';
import 'package:jiburo_app/styles/fonts.dart';
import 'package:jiburo_app/widgets/buttons/icon_btn.dart';

class PetCard extends StatefulWidget {
  final FindPetsModel pet;
  final Function() onSaveTab;
  final bool isList;
  const PetCard({
    super.key,
    required this.pet,
    required this.onSaveTab,
    this.isList = false,
  });

  @override
  State<PetCard> createState() => _PetCardState();
}

class _PetCardState extends State<PetCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 164,
          padding: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16,
            children: [
              Container(
                width: 148,
                height: 148,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(widget.pet.imgPath, fit: BoxFit.cover),
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
                          Text(
                            '${widget.pet.breeds} ${widget.pet.name}',
                            style: AppFonts.hd2SB,
                          ),
                          SizedBox(height: 4),
                          Text(widget.pet.missingSpot, style: AppFonts.l2M),
                          Text(
                            "내 위치에서 ${widget.pet.area}km 이내",
                            style: AppFonts.c2R,
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text('사례금 : ', style: AppFonts.l2M),
                              Text(
                                widget.pet.reward,
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
                          '${widget.pet.time}시간 전',
                          style: AppFonts.c2R.copyWith(
                            color: AppColors.neutral60,
                          ),
                        ),
                        IconBtn(
                          iconPath:
                              'assets/images/icons/tab-bar/ic_Save${widget.pet.isLike ? '=Active' : ''}.svg',
                          onTap: widget.onSaveTab,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        if (widget.isList)
          // 하단 구분선
          Container(
            width: double.infinity,
            height: 1,
            margin: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(color: AppColors.neutral95),
          ),
      ],
    );
  }
}
