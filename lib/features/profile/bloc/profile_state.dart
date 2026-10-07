part of 'profile_bloc.dart';

class ProfileState {
  final bool loading;
  final String? errorMessage;
  final Profile profile;
  final DiaryEntry diaryEntry;
  final DateTime selectedDate;

  ProfileState({
    required this.diaryEntry,
    required this.selectedDate,
    required this.profile,
    this.loading = false,
    this.errorMessage,
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
    bool? loading,
    String? errorMessage,
    bool resetError = false,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      diaryEntry: diaryEntry ?? this.diaryEntry,
      selectedDate: selectedDate ?? this.selectedDate,
      loading: loading ?? this.loading,
      errorMessage: resetError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
