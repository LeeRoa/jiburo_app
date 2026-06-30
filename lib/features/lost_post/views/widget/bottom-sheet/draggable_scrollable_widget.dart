import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jiburo_app/core/routes/app_paths.dart';
import 'package:jiburo_app/core/utils/auth_guard.dart';
import 'package:jiburo_app/core/views/widgets/buttons/main_btn.dart';
import 'package:jiburo_app/core/views/widgets/pet-card/card_index.dart';
import 'package:jiburo_app/models/find_pets_model.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'sheet_box.dart';
import 'sheet_handle_widget.dart';
import 'sheet_header.dart';

class DraggableScrollableWidget extends ConsumerStatefulWidget {
  final bool isOnMap;
  const DraggableScrollableWidget({super.key, required this.isOnMap});

  @override
  ConsumerState<DraggableScrollableWidget> createState() =>
      _DraggableScrollableWidgetState();
}

class _DraggableScrollableWidgetState
    extends ConsumerState<DraggableScrollableWidget> {
  double initSize = 0.5;
  double minSize = 0.1;
  double maxSize = 1.0;

  late final ValueNotifier<double> _sheetSize = ValueNotifier(initSize);

  final List<FindPetsModel> pets = [
    FindPetsModel(
      id: "1",
      name: '복돌이',
      writer: '레이맘',
      title: "복돌이를 찾아주세요",
      breeds: '강아지',
      missingSpot: '서울시 강동구 천호동',
      area: '5',
      reward: '30',
      time: '1',
      imgPath: 'assets/images/1.jpg',
      isLike: true,
    ),
    FindPetsModel(
      id: "2",
      name: '아로',
      writer: '작성자',
      title: "아로를 찾아주세요",
      breeds: '강아지',
      missingSpot: '서울시 강동구 길동',
      area: '3',
      reward: '30',
      time: '3',
      imgPath: 'assets/images/2.png',
      isLike: false,
    ),
    FindPetsModel(
      id: "3",
      name: '영숙이',
      writer: '작성자',
      title: "제목을 입력하세요",
      breeds: '고양이',
      missingSpot: '서울시 강동구 명일동',
      area: '2',
      reward: '50',
      time: '5',
      imgPath: 'assets/images/4.png',
      isLike: false,
    ),
    FindPetsModel(
      id: "4",
      name: '복돌이',
      writer: '작성자',
      title: "제목을 입력하세요",
      breeds: '강아지',
      missingSpot: '서울시 강동구 천호동',
      area: '5',
      reward: '30',
      time: '1',
      imgPath: 'assets/images/5.png',
      isLike: true,
    ),
    FindPetsModel(
      id: "5",
      name: '아로',
      writer: '작성자',
      title: "제목을 입력하세요",
      breeds: '강아지',
      missingSpot: '서울시 강동구 길동',
      area: '3',
      reward: '30',
      time: '3',
      imgPath: 'assets/images/2.png',
      isLike: false,
    ),
    FindPetsModel(
      id: "6",
      name: '레이',
      writer: '작성자',
      title: "제목을 입력하세요",
      breeds: '고양이',
      missingSpot: '서울시 강동구 고덕동',
      area: '1',
      reward: '20',
      time: '5',
      imgPath: 'assets/images/3.jpg',
      isLike: false,
    ),
    FindPetsModel(
      id: "7",
      name: '복돌이',
      writer: '작성자',
      title: "제목을 입력하세요",
      breeds: '강아지',
      missingSpot: '서울시 강동구 천호동',
      area: '5',
      reward: '30',
      time: '1',
      imgPath: 'assets/images/1.jpg',
      isLike: true,
    ),
    FindPetsModel(
      id: "8",
      name: '아로',
      writer: '작성자',
      title: "제목을 입력하세요",
      breeds: '강아지',
      missingSpot: '서울시 강동구 길동',
      area: '3',
      reward: '30',
      time: '3',
      imgPath: 'assets/images/2.png',
      isLike: false,
    ),
    FindPetsModel(
      id: "9",
      name: '레이',
      writer: '작성자',
      title: "제목을 입력하세요",
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
        _sheetSize.value = notification.extent;

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
                                    children: [SheetHandleWidget()],
                                  ),
                                ),
                              ),
                            ),

                            SliverToBoxAdapter(
                              child: SheetHeader(name: '지호', onRefresh: () {}),
                            ),

                            SliverPadding(
                              padding: const EdgeInsetsGeometry.symmetric(
                                horizontal: 16,
                              ),
                              sliver: SliverList.builder(
                                itemCount: pets.length,
                                itemBuilder: (context, index) =>
                                    CardIndex.medium(
                                      hasLine: true,
                                      pet: pets[index],

                                      onMove: () => context.push(
                                        AppPaths.postDetail(pets[index].id),
                                      ),
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
                          onTap: () {
                            if (!requireLogin(context, ref)) return;
                            context.push('/add');
                          },
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
  double get maxExtent => 44.0; // 제목 영역의 높이
  @override
  double get minExtent => 44.0; // 고정되었을 때의 높이

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
