import 'package:flutter/material.dart';
import 'package:jiburo_app/core/views/widgets/app-bar/index_app_bar.dart';
import 'package:jiburo_app/core/views/widgets/plain_layout.dart';
import 'package:jiburo_app/core/views/kakao_map_screen.dart';
import 'package:jiburo_app/features/lost_post/views/widget/bottom-sheet/draggable_scrollable_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isNew = true;
  bool isMapTab = false;

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
            ),
          ),
          DraggableScrollableWidget(isOnMap: isMapTab),
        ],
      ),
    );
  }
}
