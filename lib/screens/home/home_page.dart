import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiburo_app/screens/notification_page.dart';
import 'package:jiburo_app/styles/colors.dart';
import 'package:jiburo_app/widgets/buttons/main_btn.dart';
import 'package:jiburo_app/widgets/home/draggable_scrollable_Widget.dart';
import 'package:jiburo_app/widgets/new_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isNew = false;
  bool isOpenNotify = false;

  void onNotifyTab() {
    setState(() {
      isOpenNotify = !isOpenNotify;
    });
  }

  void onBackTab() {
    if (isOpenNotify) {
      setState(() {
        isOpenNotify = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: NewAppBar(
        isHome: isOpenNotify ? false : true,
        titleText: isOpenNotify ? '알림' : '',
        onBackTap: onBackTab,
        onTap: onNotifyTab,
        icRight: isOpenNotify
            ? null
            : SvgPicture.asset(
                isNew
                    ? 'assets/images/icons/ic_status=new.svg'
                    : 'assets/images/icons/ic_status=normal.svg',
              ),
      ),
      body: Stack(
        children: [
          // 지도 들어갈 자리
          // AbsorbPointer 레이어 됐을 때 밑바닥 터치 방지
          AbsorbPointer(
            absorbing: true,
            child: MainBtn(
              btnName: '텍스트',
              variant: Variant.primary,
              size: Size.medium,
              isExpanded: true,
            ),
          ),
          DraggableScrollableWidget(),
          if (isOpenNotify) NotificationPage(),
        ],
      ),
    );
  }
}
