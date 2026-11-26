import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jiburo_app/core/network/api_error.dart';
import 'package:jiburo_app/core/utils/unfocus_input.dart';
import 'package:jiburo_app/core/views/widgets/app-bar/index_app_bar.dart';
import 'package:jiburo_app/core/views/widgets/buttons/main_btn.dart';
import 'package:jiburo_app/core/views/widgets/input/input_with_label.dart';
import 'package:jiburo_app/core/views/widgets/plain_layout.dart';
import 'package:jiburo_app/features/user/data/user_repository.dart';
import 'package:jiburo_app/features/user/providers/user_providers.dart';
import 'package:jiburo_app/features/user/views/widget/profile_avatar.dart';

/// 프로필 수정 (현재: 닉네임)
class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  static const _minLength = 2;
  static const _maxLength = 20;

  final _controller = TextEditingController();
  String _original = '';
  String? _error;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(myProfileProvider).valueOrNull;
    _original = profile?.nickname ?? '';
    _controller.text = _original;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _nickname => _controller.text.trim();

  bool get _canSave =>
      !_saving &&
      _nickname != _original &&
      _nickname.length >= _minLength &&
      _nickname.length <= _maxLength;

  Future<void> _save() async {
    unfocusInput(context);
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.read(userRepositoryProvider).updateNickname(_nickname);
      ref.invalidate(myProfileProvider);
      if (!mounted) return;
      context.pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('프로필이 수정됐어요')));
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = apiErrorMessage(e, fallback: '프로필을 수정하지 못했어요');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(myProfileProvider).valueOrNull;
    return GestureDetector(
      onTap: () => unfocusInput(context),
      child: PlainLayout(
        appBar: IndexAppBar(type: AppBarType.notify, title: '프로필 수정'),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Column(
            children: [
              ProfileAvatar(url: profile?.profileImageUrl, size: 96),
              const SizedBox(height: 24),
              InputWithLabel(
                label: '닉네임',
                isImport: true,
                placeHolder: '닉네임을 입력해 주세요 ($_minLength~$_maxLength자)',
                controller: _controller,
                errorText: _error,
                onChanged: (_) => setState(() => _error = null),
              ),
              const Spacer(),
              MainBtn(
                btnName: '저장',
                isExpanded: true,
                isDisabled: !_canSave,
                onTap: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
