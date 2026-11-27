import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jiburo_app/core/routes/app_paths.dart';
import 'package:jiburo_app/core/utils/auth_guard.dart';
import 'package:jiburo_app/core/utils/unfocus_input.dart';
import 'package:jiburo_app/core/views/widgets/buttons/main_btn.dart';
import 'package:jiburo_app/features/lost_post/providers/post_providers.dart';
import 'package:jiburo_app/features/lost_post/views/widget/post_card.dart';
import 'package:jiburo_app/features/user/providers/user_providers.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';
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

  Timer? _searchDebounce;
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

  /// 입력이 멈추면(0.4초) 검색어를 반영
  void _onSearchChanged() {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      ref.read(homeKeywordProvider.notifier).state = _searchController.text
          .trim();
    });
  }

  void _refresh() {
    ref.invalidate(homePostsProvider);
    ref.invalidate(likedPostIdsProvider);
  }

  Future<void> _toggleLike(String postId) async {
    if (!requireLogin(context, ref)) return;
    try {
      await ref.read(likedPostIdsProvider.notifier).toggle(postId);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('저장하지 못했어요')));
    }
  }

  /// 목록 영역: 로딩 / 오류 / 빈 결과 / 게시글 카드
  Widget _postList() {
    final posts = ref.watch(homePostsProvider);
    final liked =
        ref.watch(likedPostIdsProvider).valueOrNull ?? const <String>{};
    final searching = ref.watch(homeKeywordProvider).trim().isNotEmpty;

    return posts.when(
      loading: () => const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (e, _) => SliverToBoxAdapter(
        child: _ListMessage(
          text: '게시글을 불러오지 못했어요',
          actionLabel: '다시 시도',
          onAction: _refresh,
        ),
      ),
      data: (items) => items.isEmpty
          ? SliverToBoxAdapter(
              child: _ListMessage(
                text: searching ? '검색 결과가 없어요' : '주변에 등록된 게시글이 없어요',
              ),
            )
          : SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final post = items[index];
                  return PostCard(
                    post: post,
                    liked: liked.contains(post.id),
                    onTap: () => context.push(AppPaths.postDetail(post.id)),
                    onLike: () => _toggleLike(post.id),
                  );
                },
              ),
            ),
    );
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
    _searchDebounce?.cancel();
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
                                name: ref.watch(myNicknameProvider),
                                onRefresh: _refresh,
                                searchController: _searchController,
                                searchFocusNode: _searchFocusNode,
                                onSearchChanged: (value) => _onSearchChanged(),
                                isDistanceSort:
                                    ref.watch(homeSortProvider) ==
                                    HomeSort.distance,
                                onSortChanged: (distance) =>
                                    ref
                                        .read(homeSortProvider.notifier)
                                        .state = distance
                                    ? HomeSort.distance
                                    : HomeSort.latest,
                              ),
                            ),

                            _postList(),

                            // 하단 등록하기 버튼에 가리지 않도록 여백
                            const SliverToBoxAdapter(
                              child: SizedBox(height: 80),
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

class _ListMessage extends StatelessWidget {
  final String text;
  final String? actionLabel;
  final VoidCallback? onAction;
  const _ListMessage({required this.text, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      child: Column(
        spacing: 8,
        children: [
          Text(text, style: AppFonts.b1nM.copyWith(color: AppColors.neutral60)),
          if (actionLabel != null)
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
        ],
      ),
    );
  }
}
