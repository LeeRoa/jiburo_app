import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jiburo_app/core/routes/app_paths.dart';
import 'package:jiburo_app/core/views/widgets/bottom-navigation/bottom_actions.dart';
import 'package:jiburo_app/core/views/widgets/buttons/main_btn.dart';
import 'package:jiburo_app/core/views/widgets/input/input_text_widget.dart';
import 'package:jiburo_app/features/lost_post/providers/add_post_provider.dart';
import 'package:jiburo_app/features/lost_post/providers/add_post_state.dart';
import 'package:jiburo_app/features/lost_post/views/add-post/add_post_layout.dart';
import 'package:jiburo_app/features/lost_post/views/add-post/widget/add_step.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool hasAnyInput = ref.watch(addPostProvider).stepOneInput;

    return AddPostLayout(
      isFirst: true,
      hasMap: true,
      contentWidget: [
        AddStep(currentStep: 1),
        Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () {
                  context.push(AppPaths.addPostSearch);
                },
                child: AbsorbPointer(
                  child: InputTextWidget(placeHolder: '실종 위치 지도검색'),
                ),
              ),
            ),
            SizedBox(height: 16),
            BottomActions.textMain(
              guideText: '화면을 움직여 실종 위치를 알려주세요.',
              mainBtn: MainBtn(
                btnName: '다음으로',
                isDisabled: !hasAnyInput,
                onTap: () {
                  context.push(AppPaths.addPostSecond);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
