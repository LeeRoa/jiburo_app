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
    required String breed,
    required String genderCode,
    required int reward,
    required String lostDate,
    int? age,
    int? weight,
  }) {
    final done = [...state.isDone]..[1] = true;

    state = state.copyWith(
      animalTypeCode: animalTypeCode,
      breed: breed,
      age: age,
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
    if (!state.isValid) throw Exception('필수 항목을 입력해 주세요');

    state = state.copyWith(
      visibilityCode: 'PUBLIC',
      categoryCode: 'ANIMAL',
      isDone: state.isDone,
      isLoading: true,
    );

    try {
      await ref
          .read(postRepositoryProvider)
          .createPost(
            LostPostCreateRequest(
              title: state.title!,
              content: state.content!,
              categoryCode: state.categoryCode!,
              animalTypeCode: state.animalTypeCode!,
              breed: state.breed!,
              genderCode: state.genderCode!,
              color: state.color,
              age: state.age,
              imageUrls: state.imageUrls!,
              latitude: state.latitude!,
              longitude: state.longitude!,
              foundLocation: state.foundLocation!,
              lostDate: state.lostDate!,
              reward: state.reward,
              visibilityCode: state.visibilityCode!,
            ),
          );
      reset();
    } finally {
      final done = [...state.isDone]..[3] = true;
      state = state.copyWith(isDone: done, isLoading: false);
    }
  }
}

final addPostProvider = StateNotifierProvider<AddPostNotifier, AddPostState>(
  (ref) => AddPostNotifier(),
);
