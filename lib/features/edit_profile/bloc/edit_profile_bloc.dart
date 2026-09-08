import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/profile.dart';
import '../../../data/abstract/profile_repository.dart';
import '../../../data/supabase/supabase_profile_repository.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final ProfileRepository profileRepository;
  final Profile initialProfile;

  EditProfileBloc({
    required this.initialProfile,
    ProfileRepository? profileRepository,
  })  : profileRepository =
            profileRepository ?? SupabaseProfileRepository.instance(),
        super(EditProfileState(
          profile: ProfileDto.fromProfile(initialProfile),
        )) {
    on<SetProfile>((event, emit) {
      emit(state.copyWith(profile: event.profile));
    });
  }

  onChangeProfile(ProfileDto profile) {
    add(SetProfile(profile: profile));
  }

  /// Guarda los campos editados del perfil actual sobre los que vienen de Supabase.
  Future<void> updateProfile() async {
    final current = state.profile;
    final base = ProfileDto.fromProfile(initialProfile);

    final merged = ProfileDto(
      id: current.id ?? base.id,
      userId: current.userId ?? base.userId,
      name: current.name ?? base.name,
      height: current.height ?? base.height,
      weight: current.weight ?? base.weight,
      gender: current.gender ?? base.gender,
      age: current.age ?? base.age,
      activityLevel: current.activityLevel ?? base.activityLevel,
      goal: current.goal ?? base.goal,
    );

    await profileRepository.updateProfile(merged);
  }
}
