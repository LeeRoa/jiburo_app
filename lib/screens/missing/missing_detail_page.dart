import 'package:flutter/material.dart';
import 'package:jiburo_app/models/map_position_model.dart';
import 'package:jiburo_app/models/searching_info_model.dart';
import 'package:jiburo_app/screens/missing/widget/missing_detail/missing_spot.dart';
import 'package:jiburo_app/screens/missing/widget/missing_detail/pet_detail.dart';
import 'package:jiburo_app/screens/missing/widget/missing_detail/photos_widget.dart';
import 'package:jiburo_app/styles/colors.dart';
import 'package:jiburo_app/styles/fonts.dart';
import 'package:jiburo_app/widgets/app-bar/index_app_bar.dart';
import 'package:jiburo_app/widgets/bottom-navigation/bottom_actions.dart';
import 'package:jiburo_app/widgets/buttons/main_btn.dart';
import 'package:jiburo_app/widgets/buttons/share_btn.dart';
import 'package:jiburo_app/widgets/plain_layout.dart';

class MissingDetailPage extends StatefulWidget {
  final String id;
  const MissingDetailPage({super.key, required this.id});

  @override
  State<MissingDetailPage> createState() => _MissingDetailPageState();
}

class _MissingDetailPageState extends State<MissingDetailPage> {
  final List<SearchingInfoModel> infos = [
    SearchingInfoModel(
      id: '1',
      memo: '찾은 사람의 메모를 표시합니다. 최대 2줄까지 표시합니다. 찾은 사람의 메모를 표시합니다. 최대 2줄까지 표시합니다.',
      type: SearchType.search,
      position: MapPositionModel(lat: 37.5665, lng: 126.9780),
      date: '2026.04.27',
    ),
    SearchingInfoModel(
      id: '2',
      memo: '찾은 사람의 메모를 표시합니다. 최대 2줄까지 표시합니다. 찾은 사람의 메모를 표시합니다. 최대 2줄까지 표시합니다.',
      type: SearchType.search,
      position: MapPositionModel(lat: 37.5665, lng: 126.9780),
      date: '2026.04.27',
    ),
    SearchingInfoModel(
      id: '3',
      memo: '찾은 사람의 메모를 표시합니다. 최대 2줄까지 표시합니다. 찾은 사람의 메모를 표시합니다. 최대 2줄까지 표시합니다.',
      type: SearchType.sighting,
      position: MapPositionModel(lat: 37.5665, lng: 126.9780),
      date: '2026.04.27',
    ),
  ];
  final bool isSave = true;
  final bool isComplete = false;
  final imgs = ['assets/images/1.jpg', 'assets/images/2.png'];

  @override
  Widget build(BuildContext context) {
    return PlainLayout(
      appBar: IndexAppBar(type: AppBarType.notify, title: '정보'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PhotosWidget(imgs: imgs, isComplete: isComplete),

            const SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    spacing: 12,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('고양이를 찾아주세요', style: AppFonts.hd2B),
                              Text(
                                '서울시 강동구 천호동',
                                style: AppFonts.l2SB.copyWith(
                                  color: AppColors.neutral60,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '5시간 전',
                            style: AppFonts.c1M.copyWith(
                              color: AppColors.neutral60,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        spacing: 2,
                        children: [
                          PetDetail(title: '이름', value: '레이'),
                          PetDetail(title: '동물', value: '고양이 / 코리안 숏헤어'),
                          PetDetail(title: '특징', value: '5살 / 13kg / 물지 않아요'),
                          PetDetail(title: '사례금', value: '30만원'),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    margin: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(color: AppColors.neutral95),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      '사용자가 입력한 텍스트가 표시됩니다. 사용자가 입력한 텍스트가 표시됩니다.사용자가 입력한 텍스트가 표시됩니다. 사용자가 입력한 텍스트가 표시됩니다.사용자가 입력한 텍스트가 표시됩니다.사용자가 입력한 텍스트가 표시됩니다.사용자가 입력한 텍스트가 표시됩니다.사용자가 입력한 텍스트가 표시됩니다.사용자가 입력한 텍스트가 표시됩니다.',
                      style: AppFonts.l1rR,
                    ),
                  ),
                  MissingSpot(
                    isShow: isSave && !isComplete,
                    spotAddr: '서울시 강동구 고덕로 210',
                    searchingInfos: infos,
                    onSearch: () {},
                  ),
                ],
              ),
            ),
            BottomActions.full(
              guideText: !isSave
                  ? '저장 하시면, 최종 실종 위치와 가까워질 때 알람을 보내드릴게요.'
                  : null,
              mainBtn: MainBtn(
                btnName: isSave ? '채팅하기' : '저장하기',
                onTap: () {},
                isDisabled: isComplete,
              ),
              subBtn: ShareBtn(onTap: () {}),
            ),
          ],
        ),
      ),
    );
  }
}
