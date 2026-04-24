abstract class AuthRepository {
  Future<void> login(String email, String password);
}

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<void> login(String email, String password) async {
    // TODO: replace with actual API call
    await Future.delayed(const Duration(seconds: 1));
  }
}
