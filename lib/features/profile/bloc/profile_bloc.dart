import 'dart:async';
import 'dart:developer' as developer;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/enums/enums.dart';
import '../../../core/models/daily_meal_entry.dart';
import '../../../core/models/diary_entry.dart';
import '../../../core/models/profile.dart';
import '../../../core/utils/diary_utils.dart';
import '../../../data/abstract/diary_repository.dart';
import '../../../data/abstract/profile_repository.dart';
import '../../../data/supabase/supabase_diary_repository.dart';
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
        diaryRepository = diaryRepository ?? SupabaseDiaryRepository.instance(),
        super(
          ProfileState(
            selectedDate: DateTime.now(),
            diaryEntry: DiaryEntry(date: DateTime.now(), meals: []),
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
      emit(state.copyWith(profile: event.profile, resetError: true));
    });

    on<SetProfileLoading>((event, emit) {
      emit(state.copyWith(loading: event.loading));
    });

    on<SetProfileError>((event, emit) {
      emit(state.copyWith(loading: false, errorMessage: event.errorMessage));
    });

    on<SetDiaryEntry>((event, emit) {
      emit(state.copyWith(diaryEntry: event.diaryEntry));
    });

    on<SetSelectedDate>((event, emit) {
      emit(state.copyWith(selectedDate: event.selectedDate));
      setDiaryEntry(event.selectedDate);
    });

    init();
  }

  init() async {
    setDiaryEntry(DateTime.now());
    await getProfile();
  }

Future<void> getProfile() async {
    add(SetProfileLoading(loading: true));
    try {
      final Profile profile = await profileRepository.getProfile(userId);
      add(SetProfile(profile: profile));
    } catch (e, s) {
      developer.log('Error al obtener el perfil', error: e, stackTrace: s);
      add(SetProfileError(errorMessage: 'profile.load_error'.tr()));
    }
  }

Future<void> addMeal(DailyMealEntry meal) async {
    try {
      final DiaryEntry updatedDiaryEntry = await diaryRepository.addMeal(
        meal,
        state.selectedDate,
        userId,
      );
      add(SetDiaryEntry(diaryEntry: updatedDiaryEntry));
    } catch (e, s) {
      developer.log('Error al añadir la comida', error: e, stackTrace: s);
      add(SetProfileError(errorMessage: 'profile.meal_error'.tr()));
    }
  }

  Future<void> removeMeal(Occasion occasion, String recipeId) async {
    try {
      final updatedDiaryEntry = state.diaryEntry.removeMeal(occasion, recipeId);
      if (updatedDiaryEntry.meals.isEmpty) {
        await diaryRepository.deleteDay(state.selectedDate, userId);
      } else {
        await diaryRepository.saveDay(updatedDiaryEntry, userId);
      }
      add(SetDiaryEntry(diaryEntry: updatedDiaryEntry));
    } catch (e, s) {
      developer.log('Error al eliminar la comida', error: e, stackTrace: s);
      add(SetProfileError(errorMessage: 'profile.meal_error'.tr()));
    }
  }

  void setSelectedDate(DateTime date) {
    add(SetSelectedDate(selectedDate: date));
  }

  void setDiaryEntry(DateTime date) async {
    final diaryEntry = await diaryRepository.getDay(date, userId) ??
        DiaryEntry(date: date, meals: []);
    add(SetDiaryEntry(diaryEntry: diaryEntry));
  }

  void updateDay(DiaryEntry diaryEntry) async {
    await diaryRepository.saveDay(diaryEntry, userId);
    add(SetDiaryEntry(diaryEntry: diaryEntry));
  }
}
