import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:jiburo_app/models/tab_item_model.dart';
import 'package:jiburo_app/styles/colors.dart';
import 'package:jiburo_app/styles/fonts.dart';
import 'package:lottie/lottie.dart';

class MainLayout extends StatefulWidget {
  // final List<Widget> child;
  final StatefulNavigationShell navigationShell;
  const MainLayout({super.key, required this.navigationShell});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> with TickerProviderStateMixin {
  // int _selectedIndex = 0;
  // late final StatefulNavigationShell navigationShell;
  // int? _animatingIndex;

  late final List<AnimationController> _controllers;

  final List<TabItemModel> tabs = [
    TabItemModel(
      label: '홈',
      iconPath: 'assets/images/icons/tab-bar/ic_Home.svg',
      lottiePath: 'assets/lottie/home-icon.json',
      // activeIconPath: 'assets/images/icons/tab-bar/ic_Home=Active.svg',
    ),
    TabItemModel(
      label: '메세지',
      iconPath: 'assets/images/icons/tab-bar/ic_Message.svg',
      lottiePath: 'assets/lottie/message_icon.json',
      // activeIconPath: 'assets/images/icons/tab-bar/ic_Message=Active.svg',
    ),
    TabItemModel(
      label: '저장',
      iconPath: 'assets/images/icons/tab-bar/ic_Save.svg',
      lottiePath: 'assets/lottie/save-icon.json',
      // activeIconPath: 'assets/images/icons/tab-bar/ic_Save=Active.svg',
    ),
    TabItemModel(
      label: '마이페이지',
      iconPath: 'assets/images/icons/tab-bar/ic_Profile.svg',
      lottiePath: 'assets/lottie/profile-icon.json',
      // activeIconPath: 'assets/images/icons/tab-bar/ic_Profile=Active.svg',
    ),
    TabItemModel(
      label: '메뉴',
      iconPath: 'assets/images/icons/tab-bar/ic_Menu.svg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      tabs.length,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controllers[0].forward();
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      // body: IndexedStack(index: _selectedIndex, children: widget.child),
      body: widget.navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -1),
              blurRadius: 0,
              spreadRadius: 0,
              color: Colors.black.withValues(alpha: 0.05),
            ),
          ],
        ),
        child: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            enableFeedback: false,
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.white,
            selectedItemColor: AppColors.neutral30,
            unselectedItemColor: AppColors.neutral30,
            selectedLabelStyle: AppFonts.c2M,
            unselectedLabelStyle: AppFonts.c2M,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            // onTap: (value) {
            //   if (_selectedIndex != value) {
            //     setState(() {
            //       _selectedIndex = value;
            //     });
            //   }
            // },
            // currentIndex: _selectedIndex,
            currentIndex: widget.navigationShell.currentIndex,
            onTap: (index) {
              _controllers[index]
                ..reset()
                ..forward();
              widget.navigationShell.goBranch(index);
            },
            items: tabs
                .map(
                  (tab) => BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: SvgPicture.asset(
                        tab.iconPath,
                        width: 24,
                        height: 24,
                      ),
                    ),
                    label: tab.label,
                    activeIcon: tab.activeIconPath != null
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: SvgPicture.asset(tab.activeIconPath!),
                          )
                        : tab.lottiePath != null
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: LottieBuilder.asset(
                              tab.lottiePath!,
                              repeat: false,
                              fit: BoxFit.cover,
                              controller: _controllers[tabs.indexOf(tab)],
                            ),
                          )
                        : null,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
