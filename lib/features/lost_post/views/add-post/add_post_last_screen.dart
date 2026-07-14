import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jiburo_app/core/routes/app_paths.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';
import 'package:jiburo_app/core/views/widgets/bottom-navigation/bottom_actions.dart';
import 'package:jiburo_app/core/views/widgets/buttons/main_btn.dart';
import 'package:jiburo_app/core/views/widgets/input/input_text_widget.dart';
import 'package:jiburo_app/core/views/widgets/input/input_with_label.dart';
import 'package:jiburo_app/features/lost_post/providers/add_post_provider.dart';
import 'package:jiburo_app/features/lost_post/views/add-post/add_post_layout.dart';
import 'package:jiburo_app/features/lost_post/views/add-post/widget/add_step.dart';
import 'package:jiburo_app/features/lost_post/views/add-post/widget/animated_bottom.dart';

class AddPostLastScreen extends ConsumerStatefulWidget {
  const AddPostLastScreen({super.key});

  @override
  ConsumerState<AddPostLastScreen> createState() => _AddPostLastScreenState();
}

class _AddPostLastScreenState extends ConsumerState<AddPostLastScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String? errorText;
  int maxLength = 5000;

  void handleContentChange(String value) {
    if (value.length > maxLength) {
      _contentController.text = value.substring(0, maxLength);
      _contentController.selection = TextSelection.fromPosition(
        TextPosition(offset: _contentController.text.length),
      );

      setState(() {
        errorText = '$maxLength자를 초과할 수 없습니다.';
      });
    } else {
      setState(() {
        errorText = null;
      });
    }

    setState(() {});
  }

  void submitPost() {
    ref
        .read(addPostProvider.notifier)
        .submit(
          title: _titleController.text,
          content: _contentController.text,
          ref: ref,
        );
    context.go(AppPaths.home);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = MediaQuery.of(context).viewInsets.bottom > 0;

    return AddPostLayout(
      contentWidget: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    spacing: 16,
                    children: [
                      AddStep(currentStep: 4),
                      InputWithLabel(
                        controller: _titleController,
                        isImport: true,
                        placeHolder: '게시물의 제목을 입력해주세요.',
                        label: '제목',
                      ),
                      Column(
                        spacing: 11,
                        children: [
                          Text(
                            '게시물에 개인정보(이름, 연락처, 주소 등)나 민감한 정보가 포함되지 않도록 주의해 주세요.',
                            style: AppFonts.c1M.copyWith(
                              color: AppColors.point50,
                            ),
                          ),
                          SizedBox(
                            height: 340,
                            child: Stack(
                              children: [
                                InputTextWidget(
                                  controller: _contentController,
                                  onChanged: (value) =>
                                      handleContentChange(value),
                                  isText: true,
                                  errorText: errorText,
                                  placeHolder:
                                      '실종 당시 상황이나 반려동물이 입고 있는 옷 등  찾는데 도움이 될 정보들을 알려주세요.',
                                ),
                                Positioned(
                                  left: 1,
                                  right: 1,
                                  bottom: 12,
                                  child: Container(
                                    width: double.maxFinite,
                                    padding: EdgeInsets.only(top: 8, left: 16),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                    ),
                                    child: Text(
                                      '${_contentController.text.length}/$maxLength',
                                      style: AppFonts.c2R.copyWith(
                                        color: AppColors.neutral50,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ],
                  ),
                ),
                AnimatedBottom(
                  isFocused: isFocused,
                  bottomWidget: _buildBottomActions(
                    isFocus: isFocused,
                    onTap: submitPost,
                    isDisabled: _titleController.text.isEmpty,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedBottom(
          isFocused: !isFocused,
          bottomWidget: _buildBottomActions(
            isFocus: !isFocused,
            onTap: submitPost,
            isDisabled: _titleController.text.isEmpty,
          ),
        ),
      ],
    );
  }
}

Widget _buildBottomActions({
  required bool isFocus,
  required Function() onTap,
  required bool isDisabled,
}) {
  return BottomActions.textMain(
    key: ValueKey(isFocus ? 'inline' : 'fixed'),
    guideText: '마지막 단계예요',
    mainBtn: MainBtn(btnName: '게시하기', onTap: onTap, isDisabled: isDisabled),
  );
}
