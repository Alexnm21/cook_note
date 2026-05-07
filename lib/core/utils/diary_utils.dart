import '../enums/activity_level.dart';
import '../enums/gender.dart';
import '../enums/goal.dart';
import '../models/profile.dart';

/// Calcula las calorías objetivo usando la fórmula de Mifflin-St Jeor
///
/// Pasos del cálculo:
/// 1. Calcula la Tasa Metabólica Basal (TMB)
/// 2. Multiplica por el Factor de Actividad Física (FAF)
/// 3. Ajusta según el objetivo del usuario
int getCaloriesObjective(Profile profile) {
  // 1. Calcula la Tasa Metabólica Basal (TMB)
  // Hombres: TMB = (10 × peso en kg) + (6.25 × altura en cm) - (5 × edad en años) + 5
  // Mujeres: TMB = (10 × peso en kg) + (6.25 × altura en cm) - (5 × edad en años) - 161
  double tmb;
  if (profile.gender == Gender.male) {
    tmb =
        (10 * profile.weight) + (6.25 * profile.height) - (5 * profile.age) + 5;
  } else {
    tmb = (10 * profile.weight) +
        (6.25 * profile.height) -
        (5 * profile.age) -
        161;
  }

  // Multiplicador por nivel de actividad (Factor de Actividad Física - FAF)
  double activityMultiplier = switch (profile.activityLevel) {
    ActivityLevel.sedentary => 1.2, // Sedentario (poco o ningún ejercicio)
    ActivityLevel.light => 1.375, // Ejercicio ligero (1-3 días/semana)
    ActivityLevel.moderate => 1.55, // Ejercicio moderado (3-5 días/semana)
    ActivityLevel.active => 1.72, // Ejercicio fuerte (6-7 días/semana)
    ActivityLevel.veryActive => 1.9, // Atleta (entrenamientos dobles)
  };

  // 2. Multiplica por el Factor de Actividad Física (FAF)
  double maintenanceCalories = tmb * activityMultiplier;

  // 3. Ajusta según el objetivo
  // Para mantener peso: usa el resultado del paso 2
  // Para perder peso (déficit): resta 500 calorías (para perder ~0.5 kg/semana)
  // Para ganar peso (superávit): suma calorías
  return switch (profile.goal) {
    Goal.loseWeight => (maintenanceCalories - 500).round(),
    Goal.loseWeightHealthy => (maintenanceCalories - 300).round(),
    Goal.maintainWeight => maintenanceCalories.round(),
    Goal.gainWeightHealthy => (maintenanceCalories + 300).round(),
    Goal.gainWeight => (maintenanceCalories + 500).round(),
  };
}

/// Calcula las proteínas objetivo en gramos
/// Basado en porcentaje de calorías (1g proteína = 4 kcal)
int getProteinObjective(Profile profile) {
  final caloriesObjective = getCaloriesObjective(profile);

  // Porcentaje de calorías de proteínas según el objetivo
  double proteinPercentage = switch (profile.goal) {
    Goal.loseWeight => 0.30, // 30% - más proteína para preservar músculo
    Goal.loseWeightHealthy => 0.25, // 25%
    Goal.maintainWeight => 0.20, // 20% - distribución estándar
    Goal.gainWeightHealthy => 0.25, // 25% - más proteína para ganar músculo
    Goal.gainWeight => 0.30, // 30% - alta proteína para ganancia muscular
  };

  // Calorías de proteínas / 4 kcal por gramo
  return ((caloriesObjective * proteinPercentage) / 4).round();
}

/// Calcula las grasas objetivo en gramos
/// Basado en porcentaje de calorías (1g grasa = 9 kcal)
int getFatObjective(Profile profile) {
  final caloriesObjective = getCaloriesObjective(profile);

  // Porcentaje de calorías de grasas según el objetivo
  double fatPercentage = switch (profile.goal) {
    Goal.loseWeight => 0.25, // 25% - moderado
    Goal.loseWeightHealthy => 0.30, // 30% - saludable
    Goal.maintainWeight => 0.30, // 30% - estándar
    Goal.gainWeightHealthy => 0.30, // 30% - saludable
    Goal.gainWeight => 0.25, // 25% - moderado para más espacio a carbohidratos
  };

  // Calorías de grasas / 9 kcal por gramo
  return ((caloriesObjective * fatPercentage) / 9).round();
}

/// Calcula los carbohidratos objetivo en gramos
/// Basado en el resto de calorías después de proteínas y grasas (1g carbohidrato = 4 kcal)
int getCarbsObjective(Profile profile) {
  final caloriesObjective = getCaloriesObjective(profile);
  final proteinCalories = getProteinObjective(profile) * 4;
  final fatCalories = getFatObjective(profile) * 9;

  // Las calorías restantes van a carbohidratos
  final carbsCalories = caloriesObjective - proteinCalories - fatCalories;

  // Calorías de carbohidratos / 4 kcal por gramo
  return (carbsCalories / 4).round();
}
