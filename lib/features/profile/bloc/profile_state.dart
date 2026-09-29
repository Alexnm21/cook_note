part of 'profile_bloc.dart';

class ProfileState {
  final bool loading;
  final Profile profile;
  final DiaryEntry diaryEntry;
  final DateTime selectedDate;

  ProfileState({
    required this.diaryEntry,
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
    DiaryEntry? diaryEntry,
    DateTime? selectedDate,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      diaryEntry: diaryEntry ?? this.diaryEntry,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}
