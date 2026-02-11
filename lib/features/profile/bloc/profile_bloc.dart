import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/enums/enums.dart';
import '../../../core/models/daily_meal_entry.dart';
import '../../../core/models/diary_day.dart';
import '../../../core/models/profile.dart';
import '../../../core/utils/diary_utils.dart';
import '../../../data/abstract/diary_repository.dart';
import '../../../data/abstract/profile_repository.dart';
import '../../../data/hive/hive_diary_repository.dart';
import '../../../data/supabase/supabase_profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;
  final DiaryRepository diaryRepository;
  final String userId;

  ProfileBloc({
    ProfileRepository? profileRepository,
    DiaryRepository? diaryRepository,
    required this.userId,
  })  : profileRepository =
            profileRepository ?? SupabaseProfileRepository.instance(),
        diaryRepository = diaryRepository ?? HiveDiaryRepository(),
        super(
          ProfileState(
            selectedDate: DateTime.now(),
            diaryDay: DiaryDay(date: DateTime.now(), meals: []),
            profile: Profile(
              id: 0,
              userId: '',
              name: '',
              height: 0,
              weight: 0,
              gender: Gender.male,
              age: 0,
              activityLevel: ActivityLevel.sedentary,
              goal: Goal.maintainWeight,
            ),
          ),
        ) {
    on<SetProfile>((event, emit) {
      emit(state.copyWith(profile: event.profile));
    });

    on<SetDiaryDay>((event, emit) {
      emit(state.copyWith(diaryDay: event.diaryDay));
    });

    on<SetSelectedDate>((event, emit) {
      emit(state.copyWith(selectedDate: event.selectedDate));
      setDiaryDay(event.selectedDate);
    });

    init();
  }

  init() async {
    setDiaryDay(DateTime.now());
    await getProfile();
  }

  Future<void> getProfile() async {
    final Profile profile = await profileRepository.getProfile(userId);
    add(SetProfile(profile: profile));
  }

  Future<void> addMeal(DailyMealEntry meal) async {
    try {
      final DiaryDay updatedDiaryDay = await diaryRepository.addMeal(
        meal,
        state.selectedDate,
      );
      add(SetDiaryDay(diaryDay: updatedDiaryDay));
    } catch (e) {
      developer.log(e.toString());
    }
  }

  Future<void> removeMeal(Occasion occasion, String recipeId) async {
    final updatedDiaryDay = state.diaryDay.removeMeal(occasion, recipeId);
    await diaryRepository.saveDay(updatedDiaryDay);
    add(SetDiaryDay(diaryDay: updatedDiaryDay));
  }

  void setSelectedDate(DateTime date) {
    add(SetSelectedDate(selectedDate: date));
  }

  void setDiaryDay(DateTime date) async {
    DiaryDay? diaryDay = await diaryRepository.getDay(date);
    if (diaryDay == null) {
      await diaryRepository.saveDay(DiaryDay(date: date, meals: []));
      diaryDay = DiaryDay(date: date, meals: []);
    }
    add(SetDiaryDay(diaryDay: diaryDay));
  }

  void updateDay(DiaryDay diaryDay) async {
    await diaryRepository.saveDay(diaryDay);
    add(SetDiaryDay(diaryDay: diaryDay));
  }
}
