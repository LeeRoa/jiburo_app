import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jiburo_app/core/routes/app_paths.dart';
import 'package:jiburo_app/core/utils/auth_guard.dart';
import 'package:jiburo_app/core/utils/unfocus_input.dart';
import 'package:jiburo_app/core/views/widgets/buttons/main_btn.dart';
import 'package:jiburo_app/core/views/widgets/pet-card/card_index.dart';
import 'package:jiburo_app/features/lost_post/utils/post_demo_list.dart';
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
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  final List<FindPetsModel> pets = PostDemoList.pets;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();

    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });

      if (_searchFocusNode.hasFocus) {
        _sheetController.animateTo(
          maxSize,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    // setState(() {
    //   _filteredPets = query.isEmpty
    //       ? pets
    //       : pets.where((pet) => pet.name.contains(query)).toList(); // name 필드 기준, 실제 필드명 확인 필요
    // });
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
    _searchController.dispose();
    _searchFocusNode.dispose();
    _sheetController.dispose();
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
        controller: _sheetController,
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
            onTap: () => unfocusInput(context),
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
                              child: SheetHeader(
                                name: '지호',
                                onRefresh: () {},
                                searchController: _searchController,
                                searchFocusNode: _searchFocusNode,
                                onSearchChanged: (value) {
                                  _onSearchChanged();
                                },
                              ),
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

                    if (showBtn && !_isSearchFocused)
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
                            context.push(AppPaths.addPost);
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
