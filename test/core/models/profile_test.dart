import 'package:cook_note/core/enums/activity_level.dart';
import 'package:cook_note/core/enums/gender.dart';
import 'package:cook_note/core/enums/goal.dart';
import 'package:cook_note/core/models/profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Profile.fromMap', () {
    test('parsea un mapa completo', () {
      final profile = Profile.fromMap({
        'id': 1,
        'user_id': 'user-1',
        'name': 'Ana',
        'height': 165,
        'weight': 60,
        'target_weight': 55,
        'gender': 'female',
        'age': 30,
        'activity_level': 'moderate',
        'goal': 'loseWeight',
      });

      expect(profile.id, 1);
      expect(profile.userId, 'user-1');
      expect(profile.name, 'Ana');
      expect(profile.height, 165);
      expect(profile.weight, 60);
      expect(profile.targetWeight, 55);
      expect(profile.gender, Gender.female);
      expect(profile.age, 30);
      expect(profile.activityLevel, ActivityLevel.moderate);
      expect(profile.goal, Goal.loseWeight);
    });

    test('usa los valores por defecto si faltan los enums del registro nuevo',
        () {
      final profile = Profile.fromMap({
        'id': 2,
        'user_id': 'user-2',
        'name': 'Luis',
      });

      expect(profile.height, 0);
      expect(profile.weight, 0);
      expect(profile.age, 0);
      expect(profile.targetWeight, isNull);
      expect(profile.gender, Gender.male);
      expect(profile.activityLevel, ActivityLevel.sedentary);
      expect(profile.goal, Goal.maintainWeight);
    });

    test('usa los valores por defecto si los enums son desconocidos', () {
      final profile = Profile.fromMap({
        'id': 3,
        'user_id': 'user-3',
        'name': 'Eva',
        'gender': 'noBinario',
        'activity_level': 'extremo',
        'goal': 'serInvencible',
      });

      expect(profile.gender, Gender.male);
      expect(profile.activityLevel, ActivityLevel.sedentary);
      expect(profile.goal, Goal.maintainWeight);
    });

    test('acepta numeros decimales de Supabase', () {
      final profile = Profile.fromMap({
        'id': 4,
        'user_id': 'user-4',
        'name': 'Ana',
        'height': 165.0,
        'weight': 60.0,
        'age': 30.0,
      });

      expect(profile.height, 165);
      expect(profile.weight, 60);
      expect(profile.age, 30);
    });

    test('no lanza si el mapa está vacío', () {
      expect(() => Profile.fromMap({}), returnsNormally);
    });
  });

  group('ProfileDto', () {
    test('toMap omite los valores nulos', () {
      final map = ProfileDto(
        id: 5,
        userId: 'user-5',
        name: 'Ana',
        height: 165,
        weight: 60,
        gender: Gender.female,
        age: 30,
        activityLevel: ActivityLevel.light,
        goal: Goal.gainWeightHealthy,
      ).toMap();

      expect(map.containsKey('target_weight'), isFalse);
      expect(map['gender'], 'female');
      expect(map['activity_level'], 'light');
    });

    test('toProfile resuelve los enums ausentes con los valores por defecto', () {
      final dto = ProfileDto(
        id: 6,
        userId: 'user-6',
        name: 'Luis',
        height: 0,
        weight: 0,
        gender: null,
        age: 0,
        activityLevel: null,
        goal: null,
      );

      final profile = dto.toProfile();

      expect(profile.gender, Gender.male);
      expect(profile.activityLevel, ActivityLevel.sedentary);
      expect(profile.goal, Goal.maintainWeight);
    });
  });
}
