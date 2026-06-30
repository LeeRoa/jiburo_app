abstract class AuthRepository {
  Future<void> signIn(String type);
  Future<String> reissue(); // 새 accessToken 반환, refreshToken은 내부에서 storage로 관리
}
