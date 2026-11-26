abstract class AuthRepository {
  Future<void> signIn(String type);
  Future<void> devSignIn(String nickname); // 로컬 테스트 전용 (서버 local 프로파일)
  Future<String> reissue(); // 새 accessToken 반환, refreshToken은 내부에서 storage로 관리
}
