import '../../core/enums/supabase_names.dart';
import '../../core/models/profile.dart';
import '../abstract/profile_repository.dart';
import 'base_supabase_repository.dart';

class SupabaseProfileRepository extends BaseSupabaseRepository
    implements ProfileRepository {
  static SupabaseProfileRepository? _instance;

  SupabaseProfileRepository._internal() : super(SupabaseNames.profiles.name);

  factory SupabaseProfileRepository.instance() {
    _instance ??= SupabaseProfileRepository._internal();
    return _instance!;
  }

  @override
  Future<Profile> getProfile(String userId) async {
    final Map<String, dynamic> response =
        await supabase.from(tableName).select().eq('user_id', userId).single();

    return Profile.fromMap(response);
  }

  @override
  Future<void> updateProfile(ProfileDto profile) async {
    if (profile.id == null) {
      throw Exception('Profile ID is null');
    }

    await supabase
        .from(tableName)
        .update(profile.toMap())
        .eq('id', profile.id!);
  }
}
