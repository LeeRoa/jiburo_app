import 'package:flutter/material.dart';
import 'package:jiburo_app/widgets/buttons/icon_btn.dart';
import 'package:jiburo_app/widgets/buttons/main_btn.dart';
import 'package:jiburo_app/widgets/home/draggable_scrollable_Widget.dart';
import 'package:jiburo_app/widgets/new_app_bar.dart';
import 'package:jiburo_app/widgets/plain_layout.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isNew = true;

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
              Navigator.pushNamed(context, '/notification');
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // 지도 들어갈 자리
          // AbsorbPointer 레이어 됐을 때 밑바닥 터치 방지
          AbsorbPointer(
            absorbing: false,
            child: MainBtn(
              btnName: '텍스트',
              variant: Variant.outline,
              size: Size.large,
              // isExpanded: ,
              onTap: () => print('클릭'),
            ),
          ),
          DraggableScrollableWidget(),
        ],
      ),
    );
  }
}
