import 'package:flutter/material.dart';
import 'package:jiburo_app/screens/home/kakao_map_page.dart';
import 'package:jiburo_app/screens/home/widget/bottom-sheet/draggable_scrollable_widget.dart';
import 'package:jiburo_app/widgets/app-bar/index_app_bar.dart';
import 'package:jiburo_app/widgets/plain_layout.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            child: KakaoMapPage(
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
