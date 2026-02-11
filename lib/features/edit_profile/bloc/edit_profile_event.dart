part of 'edit_profile_bloc.dart';

abstract class EditProfileEvent {}

class SetProfile extends EditProfileEvent {
  final ProfileDto profile;
  SetProfile({required this.profile});
}
