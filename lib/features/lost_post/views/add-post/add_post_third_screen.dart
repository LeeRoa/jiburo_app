import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:jiburo_app/core/routes/app_paths.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';
import 'package:jiburo_app/core/views/widgets/bottom-navigation/bottom_actions.dart';
import 'package:jiburo_app/core/views/widgets/buttons/main_btn.dart';
import 'package:jiburo_app/features/lost_post/models/image_info_text_model.dart';
import 'package:jiburo_app/features/lost_post/providers/add_post_provider.dart';
import 'package:jiburo_app/features/lost_post/utils/image_info_text_list.dart';
import 'package:jiburo_app/features/lost_post/views/add-post/add_post_layout.dart';
import 'package:jiburo_app/features/lost_post/views/add-post/widget/add_image_box.dart';
import 'package:jiburo_app/features/lost_post/views/add-post/widget/image_info_box.dart';
import 'package:jiburo_app/features/lost_post/views/add-post/widget/image_info_text.dart';
import 'package:jiburo_app/features/lost_post/views/add-post/widget/add_step.dart';

class AddPostThirdScreen extends ConsumerStatefulWidget {
  const AddPostThirdScreen({super.key});

  @override
  ConsumerState<AddPostThirdScreen> createState() => _AddPostThirdScreenState();
}

class _AddPostThirdScreenState extends ConsumerState<AddPostThirdScreen> {
  List<ImageInfoTextModel> list = ImageInfoTextList.infoList;
  bool openImgAdd = false;
  List<String> imageUrls = [];

  void handleOpenAddImg() {
    setState(() {
      openImgAdd = true;
    });
  }

  void handleNextStep() {
    final bool hasImg = imageUrls.isNotEmpty;

    if (hasImg) {
      // 이미 추가시 로직
      ref.read(addPostProvider.notifier).setUploadImages([]);
    } else {
      // 사진이 없어요
      ref.read(addPostProvider.notifier).setNoImages();
    }
    context.push(AppPaths.addPostLast);
  }

  @override
  Widget build(BuildContext context) {
    final bool hasImg = imageUrls.isNotEmpty;

    print('이미지있음?: $hasImg, $imageUrls');

    return AddPostLayout(
      contentWidget: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AddStep(currentStep: 3),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 16,
                      children: [
                        Row(
                          spacing: 4,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColors.neutral99,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    print('터치');
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/icons/ic_add-img.svg',
                                        colorFilter: const ColorFilter.mode(
                                          AppColors.neutral40,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      Text(
                                        '사진 추가',
                                        style: AppFonts.l1nM.copyWith(
                                          color: AppColors.neutral40,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 80,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return AddImageBox(
                                      isMain: index == 0,
                                      imgPath: 'assets/images/1.jpg',
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      SizedBox(width: 4),
                                  itemCount: 5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          spacing: 8,
                          children: [
                            ImageInfoBox(isFront: true),
                            ImageInfoBox(isFront: false),
                          ],
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ImageInfoText(
                              mainText: '${index + 1}. ${list[index].mainText}',
                              subText: list[index].subText,
                            );
                          },
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 16),
                          itemCount: list.length,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        if (hasImg)
          BottomActions.single(
            mainBtn: _mainNextBtn(
              onTap: () => handleNextStep(),
              isDisabled: !hasImg,
            ),
          )
        else
          BottomActions.row(
            subBtn: MainBtn(
              variant: Variant.outlineDark,
              btnName: '사진이 없어요',
              onTap: () => handleNextStep(),
            ),
            mainBtn: _mainNextBtn(
              onTap: () => handleNextStep(),
              isDisabled: !hasImg,
            ),
          ),
      ],
    );
  }
}

MainBtn _mainNextBtn({required Function() onTap, required bool isDisabled}) {
  return MainBtn(btnName: '다음으로', onTap: onTap, isDisabled: isDisabled);
}
