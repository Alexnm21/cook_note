import 'package:supabase_flutter/supabase_flutter.dart';

abstract class LoginRepository {
  Future<void> registerProfile({
    required String email,
    required String password,
    required String name,
  });

  Future<User?> loginWithEmailAndPassword(String email, String password);

  Future<void> resetPasswordForEmail(String email);
}