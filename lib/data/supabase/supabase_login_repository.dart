import 'package:easy_localization/easy_localization.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/enums/supabase_names.dart';
import '../abstract/login_repository.dart';
import 'base_supabase_repository.dart';

class SupabaseLoginRepository extends BaseSupabaseRepository
    implements LoginRepository {
  static SupabaseLoginRepository? _instance;

  // Constructor privado para el singleton
  SupabaseLoginRepository._internal() : super(SupabaseNames.profiles.name);

  /// Método factory que retorna la instancia única del repositorio
  factory SupabaseLoginRepository.instance() {
    _instance ??= SupabaseLoginRepository._internal();
    return _instance!;
  }

  @override
  Future<void> registerProfile({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final AuthResponse authResponse = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      // Verificar si el usuario fue creado exitosamente
      if (authResponse.user == null) {
        throw Exception('login.errors.user_creation_failed'.tr());
      }

      // Verificar si el usuario ya existía (aud = 'authenticated' indica usuario existente)
      // if (authResponse.user!.aud == 'authenticated') {
      //   throw Exception('login.errors.email_already_registered'.tr());
      // }

      // Solo insertar en profiles si el usuario fue creado exitosamente
      await supabase.from(tableName).insert({
        'user_id': authResponse.user!.id,
        'name': name,
      });
    } catch (e) {
      // Re-lanzar el error para que sea manejado por el BLoC
      rethrow;
    }
  }
}
