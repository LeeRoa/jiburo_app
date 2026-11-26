import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiburo_app/core/routes/app_paths.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';
import 'package:jiburo_app/core/views/widgets/bottom-navigation/bottom_actions.dart';
import 'package:jiburo_app/core/views/widgets/buttons/main_btn.dart';
import 'package:jiburo_app/features/lost_post/data/lost_post_repository_impl.dart';
import 'package:jiburo_app/features/lost_post/models/image_info_text_model.dart';
import 'package:jiburo_app/features/lost_post/services/image_compress_service.dart';
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
  List<File> selectedImages = []; // 압축 완료된 업로드 대상 파일
  bool _isUploading = false;

  Future<void> pickImages() async {
    final remaining = 10 - selectedImages.length;

    if (remaining <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('사진은 10장까지 추가 가능 합니다')));
      return;
    }
    final ImagePicker picker = ImagePicker();

    final List<XFile> images = await picker.pickMultiImage(limit: remaining);
    if (images.isEmpty) return;

    final compressed = <File>[];
    for (final image in images) {
      final file = await ImageCompressService.compressForDetail(image.path);
      if (file != null) compressed.add(file);
    }
    if (!mounted) return;

    setState(() {
      selectedImages.addAll(compressed.take(remaining));
    });
  }

  void removeImage(int index) {
    setState(() {
      selectedImages.removeAt(index);
    });
  }

  Future<void> handleNextStep() async {
    if (_isUploading) return; // 중복 탭 방지

    if (selectedImages.isEmpty) {
      // 사진이 없어요
      ref.read(addPostProvider.notifier).setNoImages();
      context.push(AppPaths.addPostLast);
      return;
    }

    setState(() => _isUploading = true);
    try {
      final repo = ref.read(postRepositoryProvider);
      final keys = <String>[];
      for (final file in selectedImages) {
        keys.add(await repo.uploadImage(file));
      }
      if (!mounted) return;
      ref.read(addPostProvider.notifier).setUploadImages(keys);
      context.push(AppPaths.addPostLast);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('사진 업로드에 실패했어요. 잠시 후 다시 시도해 주세요')),
      );
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasImg = selectedImages.isNotEmpty;

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
                              onTap: pickImages,
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColors.neutral99,
                                ),
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
                            Expanded(
                              child: SizedBox(
                                height: 80,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return AddImageBox(
                                      isMain: index == 0,
                                      imgPath: selectedImages[index].path,
                                      isFile: true,
                                      onRemove: () => removeImage(index),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      SizedBox(width: 4),
                                  itemCount: selectedImages.length,
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
              isDisabled: !hasImg || _isUploading,
            ),
          )
        else
          BottomActions.row(
            subBtn: MainBtn(
              variant: Variant.outlineDark,
              btnName: '사진이 없어요',
              onTap: () => handleNextStep(),
              isDisabled: _isUploading,
            ),
            mainBtn: _mainNextBtn(
              onTap: () => handleNextStep(),
              isDisabled: !hasImg || _isUploading,
            ),
          ),
      ],
    );
  }
}

MainBtn _mainNextBtn({required Function() onTap, required bool isDisabled}) {
  return MainBtn(btnName: '다음으로', onTap: onTap, isDisabled: isDisabled);
}
