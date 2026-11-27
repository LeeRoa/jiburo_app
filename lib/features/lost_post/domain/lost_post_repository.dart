import 'dart:io';

import 'package:jiburo_app/features/lost_post/dto/lost_post_create_request.dto.dart';
import 'package:jiburo_app/features/lost_post/dto/lost_post_detail.dart';
import 'package:jiburo_app/features/lost_post/dto/post_summary.dart';
import 'package:jiburo_app/features/lost_post/dto/presigned_url_request.dto.dart';

abstract class LostPostRepository {
  Future<void> createPost(LostPostCreateRequest request);
  Future<String> uploadImage(File file, {FileCode fileCode = FileCode.post});

  /// 내 주변 게시글 (홈 목록). sortType: DISTANCE | LATEST
  Future<List<PostSummary>> fetchNearby({
    required double lat,
    required double lng,
    String sortType = 'DISTANCE',
    int size = 20,
  });

  /// 키워드(제목 등) 검색
  Future<List<PostSummary>> searchPosts(String keyword, {int size = 20});

  /// 지도 화면 영역 안의 게시글 (마커)
  Future<List<PostSummary>> fetchMapPins({
    required double minLat,
    required double maxLat,
    required double minLng,
    required double maxLng,
    int limit = 100,
  });

  Future<LostPostDetail> fetchPost(String id);

  /// 저장(관심) 토글. 토글 후 저장 상태를 반환
  Future<bool> toggleLike(String id);

  /// 내가 저장한 게시글 (저장 탭)
  Future<List<PostSummary>> fetchLikedPosts();

  /// 내가 저장한 게시글 ID 목록
  Future<Set<String>> fetchLikedIds();

  /// 게시글 작성자용: 이 게시글의 탐색 기록
  Future<List<FinderNote>> fetchFinderNotes(String postId);
}
