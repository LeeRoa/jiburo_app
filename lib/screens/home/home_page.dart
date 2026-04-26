import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jiburo_app/routes/app_paths.dart';
import 'package:jiburo_app/screens/home/kakao_map_page.dart';
import 'package:jiburo_app/widgets/buttons/icon_btn.dart';
import 'package:jiburo_app/widgets/home/bottom-sheet/draggable_scrollable_widget.dart';
import 'package:jiburo_app/widgets/new_app_bar.dart';
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
      appBar: NewAppBar(
        isHome: true,
        actions: [
          IconBtn(
            iconPath: isNew
                ? 'assets/images/icons/ic_status=new.svg'
                : 'assets/images/icons/ic_status=normal.svg',
            onTap: () {
              context.go('/${AppPaths.notify}');
            },
          ),
        ],
      ),
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
