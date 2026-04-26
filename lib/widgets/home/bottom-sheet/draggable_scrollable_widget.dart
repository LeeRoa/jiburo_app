import 'package:flutter/material.dart';
import 'package:jiburo_app/models/find_pets_model.dart';
import 'package:jiburo_app/styles/colors.dart';
import 'package:jiburo_app/widgets/buttons/main_btn.dart';
import 'package:jiburo_app/widgets/home/bottom-sheet/sheet-handle-widget.dart';
import 'pet-card.dart';
import 'sheet-box.dart';
import 'sheet-header.dart';

class DraggableScrollableWidget extends StatefulWidget {
  final bool isOnMap;
  const DraggableScrollableWidget({super.key, required this.isOnMap});

  @override
  State<DraggableScrollableWidget> createState() =>
      _DraggableScrollableWidgetState();
}

class _DraggableScrollableWidgetState extends State<DraggableScrollableWidget> {
  double initSize = 0.5;
  double minSize = 0.1;
  double maxSize = 1.0;

  late final ValueNotifier<double> _sheetSize = ValueNotifier(initSize);
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

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

  // void _sheetListener() {
  //   final currentSize = _sheetController.size;
  //
  //   if (currentSize < initSize) {
  //     setState(() {
  //       expandedAddBtn = false;
  //       isScrolled = false;
  //     });
  //   } else {
  //     setState(() {
  //       expandedAddBtn = true;
  //       if (currentSize > initSize) {
  //         isScrolled = true;
  //       } else if (currentSize <= initSize) {
  //         isScrolled = false;
  //       }
  //     });
  //   }
  //
  //   print(currentSize);
  //
  //   setState(() {
  //     isFullScroll = currentSize == maxSize;
  //   });
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final media = MediaQuery.of(context);
    final height = media.size.height;
    final safeHeight = height - media.padding.top - media.padding.bottom;

    setState(() {
      initSize = 380 / safeHeight;
      minSize = 88 / safeHeight;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        final double currSize = notification.extent; // 현재 size
        _sheetSize.value = notification.extent;

        // isFullScroll = currSize == maxSize;
        // _isFullScroll.value = currSize == maxSize;

        // if (currSize < initSize) {
        //   expandedAddBtn = false;
        //   isScrolled = false;
        // } else {
        //   expandedAddBtn = true;
        //   if (currSize > initSize) {
        //     isScrolled = true;
        //   } else if (currSize <= initSize) {
        //     isScrolled = false;
        //   }
        // }

        return true;
      },
      child: DraggableScrollableSheet(
        key: ValueKey('$initSize-$minSize'),
        initialChildSize: initSize,
        minChildSize: minSize,
        maxChildSize: maxSize,
        snap: true,
        snapSizes: [initSize],
        snapAnimationDuration: const Duration(
          milliseconds: 300,
        ), // 200ms보다 약간 더 길게
        builder: (BuildContext context, ScrollController scrollController) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: ValueListenableBuilder<double>(
              valueListenable: _sheetSize,
              builder: (context, size, child) {
                final isFull = size == maxSize;
                final isScrolled = size > initSize;
                final showBtn = size >= initSize;

                return Stack(
                  children: [
                    SheetBox(
                      borderRadius: isFull
                          ? BorderRadius.zero
                          : BorderRadius.vertical(top: Radius.circular(16)),
                      child: RawScrollbar(
                        controller: scrollController,
                        thumbVisibility: true,
                        thickness: 3,
                        radius: const Radius.circular(8),
                        padding: EdgeInsets.only(
                          top: 218,
                          bottom: 20,
                          right: 4,
                        ),
                        child: CustomScrollView(
                          controller: scrollController,
                          physics: isFull
                              ? const AlwaysScrollableScrollPhysics()
                              : const ClampingScrollPhysics(),
                          slivers: [
                            // 스크롤 고정
                            SliverPersistentHeader(
                              pinned: true,
                              delegate: _HeaderDelegate(
                                child: ColoredBox(
                                  color: AppColors.white,
                                  child: Column(
                                    children: [
                                      SheetHandleWidget(),
                                      SheetHeader(name: '지호', onRefresh: () {}),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            SliverPadding(
                              padding: const EdgeInsetsGeometry.symmetric(
                                horizontal: 16,
                              ),
                              sliver: SliverList.builder(
                                itemCount: pets.length,
                                itemBuilder: (context, index) => PetCard(
                                  isList: true,
                                  pet: pets[index],
                                  onSaveTab: () {},
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (showBtn)
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
            ),
          );
        },
      ),
    );
  }
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
  double get maxExtent => 218.0; // 제목 영역의 높이
  @override
  double get minExtent => 218.0; // 고정되었을 때의 높이

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
