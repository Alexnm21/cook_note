part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class SetProfile extends ProfileEvent {
  final Profile profile;
  SetProfile({required this.profile});
}

class SetDiaryDay extends ProfileEvent {
  final DiaryDay diaryDay;
  SetDiaryDay({required this.diaryDay});
}

class SetSelectedDate extends ProfileEvent {
  final DateTime selectedDate;
  SetSelectedDate({required this.selectedDate});
}
