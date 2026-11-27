import 'dart:ui' as ui;

import 'package:jiburo_app/core/views/widgets/post_pin_marker.dart';
import 'package:jiburo_app/models/map_position_model.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';
import 'package:jiburo_app/core/views/widgets/buttons/main_btn.dart';
import 'package:jiburo_app/models/searching_info_model.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';

import 'searching_card.dart';

class MissingSpot extends StatelessWidget {
  final bool isShow;
  final List<SearchingInfoModel> searchingInfos;
  final String spotAddr;

  /// 저장 후 보여줄 위치 (지도 미리보기). 좌표가 없으면 덮개만 표시
  final MapPositionModel? spot;
  final VoidCallback? onSearch;

  const MissingSpot({
    super.key,
    required this.isShow,
    required this.spotAddr,
    this.spot,
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
            if (isShow && spot != null)
              _SpotMap(spot: spot!)
            else
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
                  btnName: '주변탐색',
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

/// 저장 후 보이는 실종 위치 지도 미리보기 (스크롤과 겹치지 않도록 조작 불가)
class _SpotMap extends StatelessWidget {
  final MapPositionModel spot;
  const _SpotMap({required this.spot});

  @override
  Widget build(BuildContext context) {
    final position = LatLng(spot.lat, spot.lng);
    return Container(
      width: double.infinity,
      height: 160,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: IgnorePointer(
        child: KakaoMap(
          option: KakaoMapOption(position: position, zoomLevel: 16),
          onMapReady: (controller) async {
            await controller.labelLayer.addPoi(
              position,
              style: PoiStyle(
                icon: await KImage.fromWidget(
                  const PostPinMarker(),
                  const ui.Size(48, 56),
                ),
                anchor: KPoint(0.5, 1.0),
              ),
            );
          },
        ),
      ),
    );
  }
}
