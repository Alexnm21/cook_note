import '../../core/models/profile.dart';

abstract class ProfileRepository {
  Future<Profile> getProfile(String userId);
  Future<void> updateProfile(ProfileDto profile);
}
