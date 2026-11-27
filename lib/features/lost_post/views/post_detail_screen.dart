import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jiburo_app/core/network/api_error.dart';
import 'package:jiburo_app/core/routes/app_paths.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';
import 'package:jiburo_app/core/utils/auth_guard.dart';
import 'package:jiburo_app/core/utils/formatters.dart';
import 'package:jiburo_app/core/views/widgets/app-bar/index_app_bar.dart';
import 'package:jiburo_app/core/views/widgets/bottom-navigation/bottom_actions.dart';
import 'package:jiburo_app/core/views/widgets/buttons/main_btn.dart';
import 'package:jiburo_app/core/views/widgets/buttons/share_btn.dart';
import 'package:jiburo_app/core/views/widgets/dividing-line/dividing_line.dart';
import 'package:jiburo_app/core/views/widgets/plain_layout.dart';
import 'package:jiburo_app/features/chat/data/chat_repository.dart';
import 'package:jiburo_app/features/chat/providers/chat_providers.dart';
import 'package:jiburo_app/features/lost_post/dto/lost_post_detail.dart';
import 'package:jiburo_app/features/lost_post/providers/post_providers.dart';
import 'package:jiburo_app/models/map_position_model.dart';
import 'package:jiburo_app/models/searching_info_model.dart';

import 'widget/post_detail/missing_spot.dart';
import 'widget/post_detail/pet_detail.dart';
import 'widget/post_detail/photos_widget.dart';

class PostDetailScreen extends ConsumerStatefulWidget {
  final String id;
  const PostDetailScreen({super.key, required this.id});

  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  /// 저장하기: 저장하면 정확한 위치와 채팅하기가 열림
  Future<void> _save() async {
    if (!requireLogin(context, ref)) return;
    try {
      await ref.read(likedPostIdsProvider.notifier).toggle(widget.id);
      ref.invalidate(postDetailProvider(widget.id));
    } catch (e) {
      _toast(apiErrorMessage(e, fallback: '저장하지 못했어요'));
    }
  }

  /// 채팅방 생성(기존 방 존재 시 재사용) 후 대화 화면 이동
  Future<void> _startChat() async {
    if (!requireLogin(context, ref)) return;
    try {
      final room = await ref.read(chatRepositoryProvider).createRoom(widget.id);
      if (!mounted) return;
      context.push(AppPaths.messageDetail(room.roomId));
    } catch (e) {
      final message = e is DioException
          ? apiErrorMessage(e, fallback: '채팅을 시작하지 못했어요')
          : (e is ChatException ? e.message : '채팅을 시작하지 못했어요');
      _toast(message);
    }
  }

  /// 탐색 기록 → 화면 모델 (제출 완료된 것만)
  List<SearchingInfoModel> _notes(List<FinderNote> notes) {
    final submitted = notes.where((n) => n.statusCode == 'SUBMITTED').toList();
    return [
      for (var i = 0; i < submitted.length; i++)
        SearchingInfoModel(
          id: '${i + 1}',
          type: submitted[i].resultCode == 'FOUND'
              ? SearchType.sighting
              : SearchType.search,
          memo: submitted[i].note ?? '',
          position: MapPositionModel(
            lat: submitted[i].startLatitude,
            lng: submitted[i].startLongitude,
          ),
          date: _dotDate(submitted[i].createdAt),
        ),
    ];
  }

  String _dotDate(DateTime? d) => d == null
      ? ''
      : '${d.year}.${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final detail = ref.watch(postDetailProvider(widget.id));
    return PlainLayout(
      appBar: IndexAppBar(type: AppBarType.notify, title: '정보'),
      body: detail.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              Text(
                '게시글을 불러오지 못했어요',
                style: AppFonts.b1nM.copyWith(color: AppColors.neutral60),
              ),
              TextButton(
                onPressed: () => ref.invalidate(postDetailProvider(widget.id)),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
        data: _buildBody,
      ),
    );
  }

  Widget _buildBody(LostPostDetail post) {
    final myId = ref.watch(myUserIdProvider);
    final isMine = myId != null && myId == post.authorId;
    final isSaved = post.isLiked;
    final showSpot = (isSaved || isMine) && !post.isComplete;
    final notes = isMine
        ? ref.watch(finderNotesProvider(post.id)).valueOrNull ?? const []
        : const <FinderNote>[];
    final animal = post.animal;
    final reward = post.reward > 0 ? formatRewardParts(post.reward) : null;
    final feature = animal?.featureLabel ?? '';

    return SingleChildScrollView(
      child: Column(
        children: [
          PhotosWidget(imgs: post.imageUrls, isComplete: post.isComplete),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                Column(
                  spacing: 12,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(post.title, style: AppFonts.hd2B),
                              Text(
                                post.foundLocation,
                                style: AppFonts.l2SB.copyWith(
                                  color: AppColors.neutral60,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          formatRelativeTime(post.createdAt),
                          style: AppFonts.c1M.copyWith(
                            color: AppColors.neutral60,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      spacing: 2,
                      children: [
                        if (animal != null) ...[
                          PetDetail(title: '이름', value: animal.name),
                          PetDetail(title: '동물', value: animal.typeLabel),
                          if (feature.isNotEmpty)
                            PetDetail(title: '특징', value: feature),
                        ],
                        if (reward != null)
                          PetDetail(
                            title: '사례금',
                            value: '${reward.amount}${reward.unit}',
                          ),
                      ],
                    ),
                  ],
                ),
                const DividingLine(margin: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(post.content, style: AppFonts.l1rR),
                ),
                MissingSpot(
                  isShow: showSpot,
                  spotAddr: post.foundLocation,
                  spot: post.latitude != null && post.longitude != null
                      ? MapPositionModel(
                          lat: post.latitude!,
                          lng: post.longitude!,
                        )
                      : null,
                  searchingInfos: _notes(notes),
                  onSearch: () => _toast('준비 중이에요'),
                ),
              ],
            ),
          ),
          BottomActions.full(
            guideText: (!isSaved && !isMine)
                ? '저장 하시면, 최종 실종 위치와 가까워질 때 알람을 보내드릴게요.'
                : null,
            mainBtn: MainBtn(
              btnName: isMine
                  ? '내 게시글이에요'
                  : isSaved
                  ? '채팅하기'
                  : '저장하기',
              onTap: isSaved ? _startChat : _save,
              isDisabled: post.isComplete || isMine,
            ),
            subBtn: ShareBtn(onTap: () {}),
          ),
        ],
      ),
    );
  }
}
