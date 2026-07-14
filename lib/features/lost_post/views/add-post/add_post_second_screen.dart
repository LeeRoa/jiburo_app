import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jiburo_app/core/constants/select_gender.dart';
import 'package:jiburo_app/core/provider/locale_provider.dart';
import 'package:jiburo_app/core/routes/app_paths.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:jiburo_app/core/utils/formatters.dart';
import 'package:jiburo_app/core/views/widgets/bottom-navigation/bottom_actions.dart';
import 'package:jiburo_app/core/views/widgets/buttons/main_btn.dart';
import 'package:jiburo_app/core/views/widgets/input/input_with_label.dart';
import 'package:jiburo_app/core/views/widgets/label_text.dart';
import 'package:jiburo_app/features/lost_post/providers/add_post_provider.dart';
import 'package:jiburo_app/features/lost_post/views/add-post/add_post_layout.dart';
import 'package:jiburo_app/features/lost_post/views/add-post/widget/add_step.dart';
import 'package:jiburo_app/features/lost_post/views/add-post/widget/animated_bottom.dart';
import 'package:jiburo_app/features/lost_post/views/add-post/widget/select_animal_type.dart';

class AddPostSecondScreen extends ConsumerStatefulWidget {
  const AddPostSecondScreen({super.key});

  @override
  ConsumerState<AddPostSecondScreen> createState() =>
      _AddPostSecondScreenState();
}

class _AddPostSecondScreenState extends ConsumerState<AddPostSecondScreen> {
  String selectGender = SelectGender.empty;
  DateTime? _lostDate;
  String selectedCode = '';
  String reward = '';

  final TextEditingController _lostDateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _animalTypeController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _rewardController = TextEditingController();

  Future<void> _pickLostDate() async {
    final language = ref.read(localeProvider);
    final picked = await showDatePicker(
      context: context,
      initialDate: _lostDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: Locale(language),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: AppColors.point50),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _lostDate = picked;
        _lostDateController.text = formatDate(picked, ref);
      });
    }
  }

  void handleSelectGender(String gender) {
    setState(() {
      selectGender = gender;
    });
  }

  void handleRewardChange(String value) {
    setState(() {
      reward = value;
      _rewardController.text = formatCurrency(int.parse(value));
    });
  }

  void handleNextStep() {
    ref
        .read(addPostProvider.notifier)
        .setPetInfo(
          animalTypeCode: selectedCode,
          breed: _breedController.text,
          age: int.tryParse(_ageController.text),
          weight: int.tryParse(_weightController.text),
          genderCode: selectGender,
          reward: int.tryParse(_rewardController.text) ?? 0,
          lostDate: _lostDate != null ? formatDate(_lostDate!, ref) : '',
        );

    context.push(AppPaths.addPostThird);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _animalTypeController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _genderController.dispose();
    _rewardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = MediaQuery.of(context).viewInsets.bottom > 0;
    bool hasAnyInput =
        _lostDateController.text.isNotEmpty &&
        _nameController.text.isNotEmpty &&
        _animalTypeController.text.isNotEmpty &&
        _breedController.text.isNotEmpty;

    return AddPostLayout(
      contentWidget: [
        Expanded(
          child: Column(
            children: [
              AddStep(currentStep: 2),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 24,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          spacing: 16,
                          children: [
                            GestureDetector(
                              onTap: _pickLostDate,
                              child: AbsorbPointer(
                                child: InputWithLabel(
                                  controller: _lostDateController,
                                  label: '실종날짜',
                                  isImport: true,
                                  placeHolder: '실종 날짜를 선택해 주세요.',
                                  readOnly: true,
                                  inputAction: TextInputAction.next,
                                ),
                              ),
                            ),
                            InputWithLabel(
                              controller: _nameController,
                              label: '이름',
                              isImport: true,
                              placeHolder: '실종된 동물의 이름을 입력해주세요.',
                              inputAction: TextInputAction.next,
                            ),
                            SelectAnimalType(
                              controller: _animalTypeController,
                              getCode: (value) {
                                setState(() {
                                  selectedCode = value;
                                });
                              },
                              selectedCode: selectedCode,
                            ),
                            InputWithLabel(
                              controller: _breedController,
                              label: '종 구분',
                              isImport: true,
                              placeHolder: '리트리버 / 믹스견 / 푸들 등',
                              inputAction: TextInputAction.next,
                            ),
                            Row(
                              spacing: 16,
                              children: [
                                Expanded(
                                  child: InputWithLabel(
                                    controller: _ageController,
                                    label: '나이',
                                    inputType: TextInputType.number,
                                    placeHolder: '나이 입력',
                                    inputAction: TextInputAction.next,
                                  ),
                                ),
                                Expanded(
                                  child: InputWithLabel(
                                    controller: _weightController,
                                    label: '몸무게 (kg)',
                                    placeHolder: '몸무게(정수)',
                                    inputType: TextInputType.number,
                                    inputAction: TextInputAction.next,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              spacing: 4,
                              children: [
                                LabelText(label: '성별', isImport: true),
                                Row(
                                  spacing: 4,
                                  children: [
                                    Expanded(
                                      child: MainBtn(
                                        variant:
                                            SelectGender.male == selectGender
                                            ? Variant.black
                                            : Variant.outlineGray,
                                        btnName: '남자',
                                        onTap: () => handleSelectGender(
                                          SelectGender.male,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: MainBtn(
                                        variant:
                                            SelectGender.female == selectGender
                                            ? Variant.black
                                            : Variant.outlineGray,
                                        btnName: '여자',
                                        onTap: () => handleSelectGender(
                                          SelectGender.female,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            InputWithLabel(
                              controller: _rewardController,
                              onChanged: (value) => handleRewardChange(value),
                              label: '사례금',
                              isImport: false,
                              placeHolder: '사례금을 입력해 주세요',
                              inputType: TextInputType.number,
                              inputAction: TextInputAction.next,
                            ),
                          ],
                        ),
                      ),

                      AnimatedBottom(
                        isFocused: isFocused,
                        bottomWidget: _buildBottomActions(
                          isFocus: isFocused,
                          onTap: handleNextStep,
                          isDisabled: !hasAnyInput,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        AnimatedBottom(
          isFocused: !isFocused,
          bottomWidget: _buildBottomActions(
            isFocus: !isFocused,
            onTap: handleNextStep,
            isDisabled: !hasAnyInput,
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
  return BottomActions.single(
    key: ValueKey(isFocus ? 'inline' : 'fixed'),
    mainBtn: MainBtn(btnName: '다음으로', onTap: onTap, isDisabled: isDisabled),
  );
}
