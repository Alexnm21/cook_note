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

  updateProfile() async {
    await profileRepository.updateProfile(state.profile);
  }
}
