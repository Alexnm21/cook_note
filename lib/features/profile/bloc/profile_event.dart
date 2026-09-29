part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class SetProfile extends ProfileEvent {
  final Profile profile;
  SetProfile({required this.profile});
}

class SetDiaryEntry extends ProfileEvent {
  final DiaryEntry diaryEntry;
  SetDiaryEntry({required this.diaryEntry});
}

class SetSelectedDate extends ProfileEvent {
  final DateTime selectedDate;
  SetSelectedDate({required this.selectedDate});
}
