import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';
import 'package:jiburo_app/core/views/widgets/custom-dotted/horizontal_dotted.dart';
import 'package:jiburo_app/features/lost_post/providers/add_post_provider.dart';
import 'package:jiburo_app/features/lost_post/providers/add_post_state.dart';

class AddStep extends ConsumerStatefulWidget {
  final int currentStep;
  const AddStep({super.key, required this.currentStep});

  @override
  ConsumerState<AddStep> createState() => _AddStepState();
}

class _AddStepState extends ConsumerState<AddStep> {
  @override
  Widget build(BuildContext context) {
    final AddPostState state = ref.watch(addPostProvider);

    return SizedBox(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStepLabel(
              '1',
              '실종위치',
              widget.currentStep == 1,
              state.isDone[0],
              true,
            ),
            _buildStepLabel(
              '2',
              '실종정보',
              widget.currentStep == 2,
              state.isDone[1],
              true,
            ),
            _buildStepLabel(
              '3',
              '사진등록',
              widget.currentStep == 3,
              state.isDone[2],
              true,
            ),
            _buildStepLabel(
              '4',
              '추가내용',
              widget.currentStep == 4,
              state.isDone[3],
              false,
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildStepLabel(
  String step,
  String label,
  bool isActive,
  bool isDone,
  bool hasDotted,
) {
  return SizedBox(
    width: 78,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 5,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            if (hasDotted)
              Positioned(
                top: 12,
                left: 25,
                child: SizedBox(child: HorizontalDotted()),
              ),
            Container(
              width: 24,
              height: 24,
              alignment: !isActive || isDone
                  ? Alignment.center
                  : Alignment.centerLeft,
              padding: !isActive || isDone ? null : EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                color: isActive || isDone
                    ? AppColors.blue
                    : AppColors.neutral95,
                borderRadius: BorderRadius.circular(70),
              ),
              child: !isDone
                  ? Text(
                      step,
                      style: AppFonts.c1SB.copyWith(color: AppColors.white),
                    )
                  : SvgPicture.asset('assets/images/check.svg'),
            ),
          ],
        ),
        Text(
          label,
          style: AppFonts.c1SB.copyWith(
            color: !isActive ? AppColors.neutral80 : AppColors.black,
          ),
          textAlign: TextAlign.center,
          softWrap: false,
          overflow: TextOverflow.visible,
        ),
      ],
    ),
  );
}
