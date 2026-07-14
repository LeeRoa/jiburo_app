import 'package:jiburo_app/features/lost_post/models/image_info_text_model.dart';

class ImageInfoTextList {
  static List<ImageInfoTextModel> infoList = [
    ImageInfoTextModel(
      mainText: '얼굴이 정면으로 보이는 사진을 올려주세요',
      subText: '눈, 코, 입 모양이 선명하게 보일수록 제보에 도움이 됩니다.',
    ),
    ImageInfoTextModel(
      mainText: '옆모습이 담긴 사진을 함께 올려주세요',
      subText: '체형, 귀 모양, 꼬리 길이 등 옆에서만 보이는 특징을 담을 수 있어요.',
    ),
    ImageInfoTextModel(
      mainText: '반려동물만의 특징이 담긴 사진을 추가해주세요',
      subText: '귀 끝의 흉터, 꼬리 무늬, 특이한 발 색깔 등. 찾는 데 결정적인 단서가 됩니다.',
    ),
    ImageInfoTextModel(
      mainText: '최근 3개월 이내 사진을 사용해주세요',
      subText: '털 색이나 체형이 달라진 경우, 현재 모습과 가장 가까운 사진이 도움이 됩니다.',
    ),
    ImageInfoTextModel(
      mainText: '실종 당시 착용하고 있던 사진이 있다면 추가해주세요',
      subText: '목줄·하네스·옷이 보이는 실종 당시 착용품이 중요한 단서가 됩니다.',
    ),
  ];
}
