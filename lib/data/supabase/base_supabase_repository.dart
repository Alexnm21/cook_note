import 'package:supabase_flutter/supabase_flutter.dart';

/// Clase base abstracta para todos los repositorios de Supabase
/// Proporciona funcionalidad común como el cliente de Supabase
abstract class BaseSupabaseRepository {
  /// Cliente de Supabase compartido
  final SupabaseClient supabase = Supabase.instance.client;

  /// Nombre de la tabla asociada al repositorio
  final String tableName;

  /// Constructor protegido que debe ser llamado por las clases hijas
  BaseSupabaseRepository(this.tableName);
}
