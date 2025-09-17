abstract class LoginRepository {
  Future<void> registerProfile({
    required String email,
    required String password,
    required String name,
  });
}
