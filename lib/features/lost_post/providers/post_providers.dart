import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiburo_app/core/network/token_holder.dart';
import 'package:jiburo_app/features/auth/providers/auth_provider.dart';
import 'package:jiburo_app/features/lost_post/data/lost_post_repository_impl.dart';
import 'package:jiburo_app/features/lost_post/dto/lost_post_detail.dart';
import 'package:jiburo_app/features/lost_post/dto/post_summary.dart';
import 'package:jiburo_app/features/lost_post/providers/location_state.dart';

enum HomeSort { distance, latest }

/// 위치를 모를 때 기본 중심 (서울시청)
const _defaultLat = 37.5665;
const _defaultLng = 126.9780;

final homeSortProvider = StateProvider<HomeSort>((ref) => HomeSort.distance);

/// 홈 검색어. 비어 있으면 내 주변 게시글
final homeKeywordProvider = StateProvider<String>((ref) => '');

/// 홈 목록: 검색어가 있으면 검색, 없으면 내 주변(거리순/최신순)
final homePostsProvider = FutureProvider.autoDispose<List<PostSummary>>((
  ref,
) async {
  final repo = ref.watch(postRepositoryProvider);
  final keyword = ref.watch(homeKeywordProvider).trim();
  final sort = ref.watch(homeSortProvider);
  ref.watch(authProvider);

  if (keyword.isNotEmpty) {
    final found = await repo.searchPosts(keyword);
    return sort == HomeSort.distance ? found.sortedByDistance() : found;
  }
  return repo.fetchNearby(
    lat: LocationState.lat ?? _defaultLat,
    lng: LocationState.lng ?? _defaultLng,
    sortType: sort == HomeSort.distance ? 'DISTANCE' : 'LATEST',
  );
});

/// 내가 저장한 게시글 ID (하트 표시용). 목록 응답에는 저장 여부가 없어서 따로 관리
class LikedIdsNotifier extends AsyncNotifier<Set<String>> {
  @override
  Future<Set<String>> build() async {
    ref.watch(authProvider);
    if (TokenHolder.accessToken == null) return <String>{};
    return ref.watch(postRepositoryProvider).fetchLikedIds();
  }

  /// 저장/해제 토글. 토글 후 저장 상태를 반환
  Future<bool> toggle(String postId) async {
    final liked = await ref.read(postRepositoryProvider).toggleLike(postId);
    final next = {...?state.valueOrNull};
    liked ? next.add(postId) : next.remove(postId);
    state = AsyncData(next);
    return liked;
  }
}

final likedPostIdsProvider =
    AsyncNotifierProvider<LikedIdsNotifier, Set<String>>(LikedIdsNotifier.new);

/// 게시글 상세
final postDetailProvider = FutureProvider.autoDispose
    .family<LostPostDetail, String>((ref, id) {
      ref.watch(authProvider);
      return ref.watch(postRepositoryProvider).fetchPost(id);
    });

/// 탐색 기록 (게시글 작성자 전용 API)
final finderNotesProvider = FutureProvider.autoDispose
    .family<List<FinderNote>, String>(
      (ref, postId) =>
          ref.watch(postRepositoryProvider).fetchFinderNotes(postId),
    );
