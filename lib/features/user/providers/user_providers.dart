import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiburo_app/core/network/token_holder.dart';
import 'package:jiburo_app/features/auth/providers/auth_provider.dart';
import 'package:jiburo_app/features/user/data/user_repository.dart';
import 'package:jiburo_app/features/user/dto/user_dtos.dart';

/// 내 프로필. 로그인/로그아웃이 바뀌면 다시 불러옴
final myProfileProvider = FutureProvider.autoDispose<UserProfile>((ref) {
  ref.watch(authProvider);
  return ref.watch(userRepositoryProvider).getMyProfile();
});

/// 내 게시물 ([size]개). 마이페이지 미리보기는 3개, 전체보기는 넉넉히
final myPostsProvider = FutureProvider.autoDispose.family<MyPostsPage, int>((
  ref,
  size,
) {
  ref.watch(authProvider);
  if (TokenHolder.accessToken == null) {
    return const MyPostsPage(items: [], total: 0);
  }
  return ref.watch(userRepositoryProvider).getMyPosts(size: size);
});

/// 내 활동(탐색 세션) [size]개
final myActivitiesProvider = FutureProvider.autoDispose
    .family<List<MyActivity>, int>((ref, size) {
      ref.watch(authProvider);
      if (TokenHolder.accessToken == null) return const <MyActivity>[];
      return ref.watch(userRepositoryProvider).getMyActivities(size: size);
    });
