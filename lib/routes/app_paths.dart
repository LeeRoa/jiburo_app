class AppPaths {
  static const splash = '/splash';
  static const login = '/login';
  static const notify = '/notification';

  // bottom menu routes
  // home
  static const home = '/';
  static const message = '/message';
  static const save = '/save';
  static const profile = '/profile';
  static const menu = '/menu';

  // 실종정보 상세
  static const info = '/info/:id';

  // 실종등록
  static const addMissing = '/add';
  // 등록 단계 쿼리
  static const addStageLocation = 'location';
  static const addStageContent = 'content';
  static const addStagePhotos = 'photos';
  static const addStageMemo = 'memo';
}
