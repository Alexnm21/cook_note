part of 'edit_profile_bloc.dart';

class EditProfileState {
  final ProfileDto profile;

  EditProfileState({required this.profile});

  EditProfileState copyWith({ProfileDto? profile}) {
    return EditProfileState(profile: profile ?? this.profile);
  }
}
