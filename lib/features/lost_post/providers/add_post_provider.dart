import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiburo_app/features/lost_post/data/lost_post_repository_impl.dart';
import 'package:jiburo_app/features/lost_post/dto/lost_post_create_request.dto.dart';
import 'package:jiburo_app/features/lost_post/providers/add_post_state.dart';

class AddPostNotifier extends StateNotifier<AddPostState> {
  AddPostNotifier() : super(AddPostState());

  void reset() {
    state = AddPostState();
  }

  // step 1
  void setLocation({
    required double lat,
    required double lng,
    required String locationName,
    required String address,
  }) {
    final done = [...state.isDone]..[0] = true;

    state = state.copyWith(
      latitude: lat,
      longitude: lng,
      locationName: locationName,
      foundLocation: address,
      isDone: done,
    );
  }

  // step 2 완료
  void setPetInfo({
    required String animalTypeCode,
    String? animalTypeCustom,
    required String breed,
    required String genderCode,
    required int reward,
    required DateTime lostDate,
    String? name,
    int? age,
    int? weight,
  }) {
    final done = [...state.isDone]..[1] = true;

    state = state.copyWith(
      name: name,
      animalTypeCode: animalTypeCode,
      animalTypeCustom: animalTypeCustom,
      breed: breed,
      age: age,
      weight: weight,
      genderCode: genderCode,
      reward: reward,
      lostDate: lostDate,
      isDone: done,
    );
  }

  // step 3 - 이미지 받을 때
  void setUploadImages(List<String> urls) {
    final done = [...state.isDone]..[2] = true;
    state = state.copyWith(imageUrls: urls, isDone: done);
  }

  // step 3 - 이미지 없을 때
  void setNoImages() {
    final done = [...state.isDone]..[2] = true;
    state = state.copyWith(imageUrls: [], isDone: done);
  }

  // step 4 - 최종 제출
  Future<void> submit({
    required String title,
    required String content,
    required WidgetRef ref,
  }) async {
    // 마지막 단계 입력값을 state에 반영한 뒤 검증 (이전에는 저장하지 않아 state.title!이 null이었음)
    state = state.copyWith(
      title: title,
      content: content,
      visibilityCode: 'PUBLIC',
      categoryCode: 'ANIMAL',
      isDone: state.isDone,
      isLoading: true,
    );

    if (!state.isValid) {
      state = state.copyWith(isDone: state.isDone, isLoading: false);
      throw Exception('필수 항목을 입력해 주세요');
    }

    try {
      await ref
          .read(postRepositoryProvider)
          .createPost(
            LostPostCreateRequest(
              title: state.title!,
              content: state.content!,
              categoryCode: state.categoryCode!,
              name: state.name,
              animalTypeCode: state.animalTypeCode!,
              animalTypeCustom: state.animalTypeCustom,
              breed: state.breed,
              genderCode: state.genderCode!,
              color: state.color,
              age: state.age,
              weight: state.weight,
              imageUrls: state.imageUrls!,
              latitude: state.latitude!,
              longitude: state.longitude!,
              foundLocation: state.foundLocation!,
              lostDate: state.lostDate!,
              reward: state.reward,
              visibilityCode: state.visibilityCode!,
            ),
          );
      reset(); // 성공 시에만 입력값 초기화 (실패하면 사용자가 다시 시도할 수 있게 유지)
    } catch (_) {
      state = state.copyWith(isDone: state.isDone, isLoading: false);
      rethrow;
    }
  }
}

final addPostProvider = StateNotifierProvider<AddPostNotifier, AddPostState>(
  (ref) => AddPostNotifier(),
);
