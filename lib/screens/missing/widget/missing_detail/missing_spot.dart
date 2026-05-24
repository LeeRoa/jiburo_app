import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiburo_app/models/searching_info_model.dart';
import 'package:jiburo_app/screens/missing/widget/missing_detail/searching_card.dart';
import 'package:jiburo_app/styles/colors.dart';
import 'package:jiburo_app/styles/fonts.dart';
import 'package:jiburo_app/widgets/buttons/main_btn.dart';

class MissingSpot extends StatelessWidget {
  final bool isShow;
  final List<SearchingInfoModel> searchingInfos;
  final String spotAddr;
  final VoidCallback? onSearch;

  const MissingSpot({
    super.key,
    required this.isShow,
    required this.spotAddr,
    required this.searchingInfos,
    this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    final search = onSearch;

    return Column(
      spacing: 16,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Row(
              spacing: 8,
              children: [
                Text('실종 위치 정보', style: AppFonts.b2nSB),
                if (isShow)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        spotAddr,
                        style: AppFonts.b2nR.copyWith(
                          color: AppColors.neutral60,
                        ),
                      ),
                      SvgPicture.asset('assets/images/icons/ic_Move-arrow.svg'),
                    ],
                  ),
              ],
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: 160,
                  margin: isShow ? null : EdgeInsets.only(bottom: 11),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black.withValues(alpha: 0.6),
                  ),
                ),
                Text(
                  '정확한 위치는 저장 후 확인할 수 있어요',
                  style: AppFonts.l1nM.copyWith(color: Colors.white),
                ),
              ],
            ),
            if (isShow && search != null)
              SizedBox(
                width: double.infinity,
                child: MainBtn(
                  btnName: '탐색하기',
                  onTap: onSearch!,
                  variant: Variant.outline,
                ),
              ),
          ],
        ),
        if (isShow)
          Container(
            margin: EdgeInsets.only(bottom: 49),
            child: ListView.builder(
              // listView 안에 column이 있으면 충돌나서 설정해줘야 함
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: searchingInfos.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == searchingInfos.length - 1 ? 0 : 8,
                  ),
                  child: SearchingCard(info: searchingInfos[index]),
                );
              },
            ),
          ),
      ],
    );
  }
}
