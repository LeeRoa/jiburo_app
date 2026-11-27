import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jiburo_app/core/routes/app_paths.dart';
import 'package:jiburo_app/features/lost_post/data/lost_post_repository_impl.dart';
import 'package:jiburo_app/features/lost_post/dto/post_summary.dart';
import 'package:jiburo_app/core/views/widgets/app-bar/index_app_bar.dart';
import 'package:jiburo_app/core/views/widgets/plain_layout.dart';
import 'package:jiburo_app/core/views/kakao_map_screen.dart';
import 'package:jiburo_app/features/lost_post/views/widget/bottom-sheet/draggable_scrollable_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool isNew = true;
  bool isMapTab = false;

  /// 지도에 표시할 게시글 마커 (지도 화면 영역 기준)
  List<PostSummary> _pins = const [];

  Future<void> _loadPins(
    double minLat,
    double maxLat,
    double minLng,
    double maxLng,
  ) async {
    try {
      final pins = await ref
          .read(postRepositoryProvider)
          .fetchMapPins(
            minLat: minLat,
            maxLat: maxLat,
            minLng: minLng,
            maxLng: maxLng,
          );
      if (mounted) setState(() => _pins = pins);
    } catch (_) {
      // 마커 조회 실패 시 기존 마커 유지
    }
  }

  // 지도 터치 하단스크롤바 내려감
  void setMapTab(bool value) {
    if (isMapTab == value) return;
    setState(() => isMapTab = value);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlainLayout(
      appBar: IndexAppBar(type: AppBarType.home),
      body: Stack(
        children: [
          // 지도 들어갈 자리
          // AbsorbPointer 레이어 됐을 때 밑바닥 터치 (false)
          AbsorbPointer(
            absorbing: false,
            child: KakaoMapScreen(
              onTap: () => setMapTab(true),
              onTapReset: () => setMapTab(false),
              pins: _pins,
              onViewportChanged: _loadPins,
              onPinTap: (id) => context.push(AppPaths.postDetail(id)),
            ),
          ),
          DraggableScrollableWidget(isOnMap: isMapTab),
        ],
      ),
    );
  }
}
