import 'package:flutter/material.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';
import 'package:jiburo_app/core/views/widgets/label/number_label.dart';
import 'package:jiburo_app/models/searching_info_model.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';

class SearchingCard extends StatelessWidget {
  final SearchingInfoModel info;
  const SearchingCard({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final type = info.type == SearchType.search ? '탐색' : '목격';

    return Column(
      spacing: 8,
      children: [
        Row(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NumberLabel(number: info.id),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Text('이 근처를 $type했어요', style: AppFonts.b2nSB),
                  Text(
                    info.memo,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppFonts.l2M,
                  ),
                  Text(
                    info.date,
                    style: AppFonts.c1M.copyWith(color: AppColors.neutral60),
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          width: double.infinity,
          height: 1,
          margin: EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(color: AppColors.neutral95),
        ),
      ],
    );
  }
}
