import 'package:flutter/material.dart';
import 'package:jiburo_app/styles/colors.dart';
import 'package:jiburo_app/styles/fonts.dart';
import 'package:jiburo_app/widgets/buttons/icon_btn.dart';
import 'package:jiburo_app/widgets/buttons/main_btn.dart';
import 'package:jiburo_app/widgets/input_text_widget.dart';

class FindPetsModel {
  final String name;
  final String breeds;
  final String missingSpot;
  final String area;
  final String reward;
  final String time;
  final String imgPath;
  final bool isLike;
  FindPetsModel({
    required this.name,
    required this.breeds,
    required this.missingSpot,
    required this.area,
    required this.reward,
    required this.time,
    required this.imgPath,
    required this.isLike,
  });
}

class DraggableScrollableWidget extends StatefulWidget {
  const DraggableScrollableWidget({super.key});
  @override
  State<DraggableScrollableWidget> createState() =>
      _DraggableScrollableWidgetState();
}

class _DraggableScrollableWidgetState extends State<DraggableScrollableWidget> {
  bool isScrolled = false;
  final DraggableScrollableController sheetController =
      DraggableScrollableController();
  bool isSearchMode = false;

  final List<FindPetsModel> pets = [
    FindPetsModel(
      name: '복돌이',
      breeds: '강아지',
      missingSpot: '서울시 강동구 천호동',
      area: '5',
      reward: '30',
      time: '1',
      imgPath: 'assets/images/1.jpg',
      isLike: true,
    ),
    FindPetsModel(
      name: '아로',
      breeds: '강아지',
      missingSpot: '서울시 강동구 길동',
      area: '3',
      reward: '30',
      time: '3',
      imgPath: 'assets/images/2.png',
      isLike: false,
    ),
    FindPetsModel(
      name: '영숙이',
      breeds: '고양이',
      missingSpot: '서울시 강동구 명일동',
      area: '2',
      reward: '50',
      time: '5',
      imgPath: 'assets/images/4.png',
      isLike: false,
    ),
    FindPetsModel(
      name: '복돌이',
      breeds: '강아지',
      missingSpot: '서울시 강동구 천호동',
      area: '5',
      reward: '30',
      time: '1',
      imgPath: 'assets/images/5.png',
      isLike: true,
    ),
    FindPetsModel(
      name: '아로',
      breeds: '강아지',
      missingSpot: '서울시 강동구 길동',
      area: '3',
      reward: '30',
      time: '3',
      imgPath: 'assets/images/2.png',
      isLike: false,
    ),
    FindPetsModel(
      name: '레이',
      breeds: '고양이',
      missingSpot: '서울시 강동구 고덕동',
      area: '1',
      reward: '20',
      time: '5',
      imgPath: 'assets/images/3.jpg',
      isLike: false,
    ),
    FindPetsModel(
      name: '복돌이',
      breeds: '강아지',
      missingSpot: '서울시 강동구 천호동',
      area: '5',
      reward: '30',
      time: '1',
      imgPath: 'assets/images/1.jpg',
      isLike: true,
    ),
    FindPetsModel(
      name: '아로',
      breeds: '강아지',
      missingSpot: '서울시 강동구 길동',
      area: '3',
      reward: '30',
      time: '3',
      imgPath: 'assets/images/2.png',
      isLike: false,
    ),
    FindPetsModel(
      name: '레이',
      breeds: '고양이',
      missingSpot: '서울시 강동구 고덕동',
      area: '1',
      reward: '20',
      time: '5',
      imgPath: 'assets/images/3.jpg',
      isLike: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  void onTapSearchMode() {
    setState(() {
      isSearchMode = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final height = media.size.height;
    final safeHeight = height - media.padding.top - media.padding.bottom;

    final minSize = 380 / safeHeight; // 실제 픽셀 기준으로 비율 계산

    sheetController.addListener(() {
      final currentSize = sheetController.size;

      if (currentSize > minSize && !isScrolled) {
        setState(() {
          isScrolled = true;
        });
      } else if (currentSize == minSize && isScrolled) {
        setState(() {
          isScrolled = false;
        });
      }
    });

    return DraggableScrollableSheet(
      controller: sheetController,
      initialChildSize: minSize,
      minChildSize: minSize,
      maxChildSize: 1,
      builder: (BuildContext context, ScrollController scrollController) {
        return Stack(
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    offset: const Offset(0, 4),
                    blurRadius: 4,
                    spreadRadius: 10,
                  ),
                ],
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: RawScrollbar(
                controller: scrollController,
                thumbVisibility: true,
                thickness: 3,
                radius: const Radius.circular(8),
                padding: EdgeInsets.only(top: 124, bottom: 20, right: 4),
                child: CustomScrollView(
                  controller: scrollController,
                  // scrollBehavior: ScrollBehavior().copyWith(overscroll: false),
                  // physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    // 스크롤 고정
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _HeaderDelegate(
                        child: Container(
                          decoration: BoxDecoration(color: AppColors.white),
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              Container(
                                width: 142,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: AppColors.neutral50,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Container(
                                color: AppColors.white, // 배경색이 있어야 리스트가 뒤로 가려짐
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: isSearchMode
                                      ? [
                                          InputTextWidget(
                                            placeHolder: '지역명/이름을 검색해보세요',
                                          ),
                                        ]
                                      : [
                                          Text(
                                            '지호님, 친구들을 찾아\n집으로 보내주세요',
                                            style: AppFonts.hd2SB,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            spacing: 16,
                                            // icons
                                            children: [
                                              IconBtn(
                                                iconPath:
                                                    'assets/images/icons/ic_Search.svg',
                                                onTap: () => onTapSearchMode(),
                                              ),
                                              IconBtn(
                                                iconPath:
                                                    'assets/images/icons/ic_Refresh.svg',
                                                onTap: () {
                                                  print('새로고침 클릭');
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SliverPadding(
                      padding: const EdgeInsetsGeometry.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _buildPetItem(pets[index]),
                          childCount: pets.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 16,
              bottom: 14,
              child: MainBtn(
                btnName: '등록하기',
                icLeft: 'assets/images/icons/ic_Plus.svg',
                isIconOnly: isScrolled,
                resizeBorderRadius: 40,
                size: Size.medium,
                onTap: () {},
              ),
            ),
          ],
        );
      },
    );
  }
}

Widget _buildPetItem(FindPetsModel pet) {
  return Column(
    children: [
      Container(
        height: 164,
        padding: EdgeInsets.all(8),
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
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
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
                        Text(
                          '${pet.breeds} ${pet.name}',
                          style: AppFonts.hd2SB,
                        ),
                        SizedBox(height: 4),
                        Text(pet.missingSpot, style: AppFonts.l2M),
                        Text("내 위치에서 ${pet.area}km 이내", style: AppFonts.c2R),
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
                      IconBtn(
                        iconPath:
                            'assets/images/icons/tab-bar/ic_Save${pet.isLike ? '=Active' : ''}.svg',
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

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

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _HeaderDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => 124.0; // 제목 영역의 높이
  @override
  double get minExtent => 124.0; // 고정되었을 때의 높이

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
