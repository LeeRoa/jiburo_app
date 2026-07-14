import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jiburo_app/core/routes/app_paths.dart';
import 'package:jiburo_app/core/utils/unfocus_input.dart';
import 'package:jiburo_app/core/views/kakao_map_screen.dart';
import 'package:jiburo_app/core/views/widgets/app-bar/index_app_bar.dart';
import 'package:jiburo_app/core/views/widgets/plain_layout.dart';
import 'package:jiburo_app/features/lost_post/providers/add_post_provider.dart';

class AddPostLayout extends StatelessWidget {
  final bool hasMap;
  final bool isFirst;
  final bool isSearch;
  final List<Widget> contentWidget;
  const AddPostLayout({
    super.key,
    this.hasMap = false,
    this.isFirst = false,
    this.isSearch = false,
    required this.contentWidget,
  });

  @override
  Widget build(BuildContext context) {
    return PlainLayout(
      appBar: IndexAppBar(
        type: AppBarType.addPost,
        title: '실종정보 등록',
        isFirst: isFirst,
        isSearch: isSearch,
      ),
      body: GestureDetector(
        onTap: () => unfocusInput(context),
        child: Stack(
          children: [
            if (hasMap)
              AbsorbPointer(
                absorbing: false,
                child: KakaoMapScreen(
                  onTap: () => {},
                  onTapReset: () => {},
                  floatingBottom: 180,
                  hasPin: true,
                ),
              ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: isFirst
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.start,
              children: contentWidget,
            ),
          ],
        ),
      ),
    );
  }
}
