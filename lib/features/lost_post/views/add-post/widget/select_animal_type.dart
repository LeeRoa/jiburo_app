import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiburo_app/core/constants/common_code_group.dart';
import 'package:jiburo_app/core/dto/common_code_response.dto.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';
import 'package:jiburo_app/core/utils/i18n_manager.dart';
import 'package:jiburo_app/core/views/widgets/input/input_with_label.dart';
import 'package:jiburo_app/features/common_code/providers/common_code_provider.dart';

class SelectAnimalType extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final String selectedCode;
  final Function(String code) getCode;

  const SelectAnimalType({
    super.key,
    required this.controller,
    required this.selectedCode,
    required this.getCode,
  });

  @override
  ConsumerState<SelectAnimalType> createState() => _SelectAnimalTypeState();
}

class _SelectAnimalTypeState extends ConsumerState<SelectAnimalType> {
  List<CommonCodeResponse> _options = [];

  Future<String?> showAnimalTypeSheet(
    BuildContext context,
    List<CommonCodeResponse> options,
    String? selectedCode,
  ) {
    return showModalBottomSheet<String>(
      context: context,
      useSafeArea: true,
      backgroundColor: AppColors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: ListView(
            shrinkWrap: true,
            children: options.reversed.map((e) {
              final isSelected = e.code == selectedCode;

              print(isSelected);
              final key = I18nManager.translate(e.messageKey!);
              return ListTile(
                title: Text(key, style: AppFonts.b1nR),
                trailing: isSelected ? const Icon(Icons.check) : null,
                onTap: () => Navigator.pop(context, e.code),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void handleOnChange(String code) {
    final matched = _options.firstWhereOrNull((e) => e.code == code);
    final label = matched != null
        ? I18nManager.translate(matched.messageKey!)
        : '';

    setState(() {
      widget.controller.text = label;
    });
    widget.getCode(code);
  }

  @override
  Widget build(BuildContext context) {
    final codeState = ref.watch(commonCodeProvider); // family 아니라 전체 provider

    return codeState.when(
      data: (codeMap) {
        final options = codeMap.byGroup(
          CommonCodeGroup.animal,
        ); // extension 그대로 사용
        _options = options;

        return GestureDetector(
          onTap: () async {
            final result = await showAnimalTypeSheet(
              context,
              options,
              widget.selectedCode,
            );

            print('선택동물: $result');
            if (result != null) handleOnChange(result);
          },
          child: AbsorbPointer(
            child: InputWithLabel(
              placeHolder: '선택해 주세요',
              label: '실종 동물',
              controller: widget.controller,
              readOnly: true,
              isImport: true,
            ),
          ),
        );
      },
      loading: () => const SizedBox(
        height: 56,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const Text('목록을 불러오지 못했어요'),
    );
  }
}
