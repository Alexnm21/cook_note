part of 'profile_bloc.dart';

class ProfileState {
  final bool loading;
  final Profile profile;
  final DiaryDay diaryDay;
  final DateTime selectedDate;

  ProfileState({
    required this.diaryDay,
    required this.selectedDate,
    required this.profile,
    this.loading = false,
  });

  int macroObjective(Macros macro) {
    return switch (macro) {
      Macros.calories => getCaloriesObjective(profile),
      Macros.protein => getProteinObjective(profile),
      Macros.carbs => getCarbsObjective(profile),
      Macros.fat => getFatObjective(profile),
    };
  }

  ProfileState copyWith({
    Profile? profile,
    DiaryDay? diaryDay,
    DateTime? selectedDate,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      diaryDay: diaryDay ?? this.diaryDay,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}
