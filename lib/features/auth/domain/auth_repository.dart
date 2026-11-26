abstract class AuthRepository {
  Future<void> signIn(String type);
  Future<void> devSignIn(String nickname); // 로컬 테스트 전용 (서버 local 프로파일)
  Future<String> reissue(); // 새 accessToken 반환, refreshToken은 내부에서 storage로 관리
  Future<void> logout(); // 서버에 로그아웃 알림 (액세스 토큰 무효화, 리프레시 토큰 삭제)
}
