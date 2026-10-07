import 'package:cook_note/core/enums/macros.dart';
import 'package:cook_note/core/models/ingredient.dart';
import 'package:cook_note/core/models/recipe.dart';
import 'package:flutter_test/flutter_test.dart';

/// Los macros se guardan en la BD como el TOTAL de la receta tal como fue
/// escrita, para sus `portions`. El escalado a otras porciones ocurre en
/// `addPortion`/`removePortion`, nunca en el servicio de IA.
void main() {
  Recipe buildRecipe({
    required int portions,
    required double calories,
  }) {
    return Recipe(
      id: 'recipe-1',
      userId: 'user-1',
      name: 'Tarta de manzana',
      ingredients: const [],
      steps: const [],
      occasions: const [],
      portions: portions,
      macros: {
        Macros.calories: calories,
        Macros.protein: 40,
        Macros.carbs: 80,
        Macros.fat: 20,
      },
    );
  }

  group('Recipe', () {
    test('los macros guardados son el total para sus porciones', () {
      final recipe = buildRecipe(portions: 4, calories: 1000);

      expect(recipe.calories, 1000);
    });

    test('removePortion de 4 a 2 muestra la mitad de las calorías', () {
      final recipe = buildRecipe(portions: 4, calories: 1000);

      final scaled = recipe.removePortion().removePortion();

      expect(scaled.portions, 2);
      expect(scaled.calories, 500);
    });

    test('addPortion de 2 a 4 vuelve a las calorías originales', () {
      final recipe = buildRecipe(portions: 4, calories: 1000);

      final scaled = recipe.removePortion().removePortion().addPortion().addPortion();

      expect(scaled.portions, 4);
      expect(scaled.calories, closeTo(1000, 0.001));
    });

    test('removePortion mantiene los macros por porción constantes', () {
      final recipe = buildRecipe(portions: 4, calories: 1000);

      final scaled = recipe.removePortion();

      expect(scaled.calories / scaled.portions, recipe.calories / recipe.portions);
    });

    test('removePortion no baja de 1 porción', () {
      final recipe = buildRecipe(portions: 1, calories: 250);

      final scaled = recipe.removePortion();

      expect(scaled.portions, 1);
      expect(scaled.calories, 250);
    });
  });

  group('Ingredient', () {
    test('los macronutrientes escalan por los gramos', () {
      final ingredient = Ingredient(
        name: 'Harina',
        grams: 200,
        caloriesByGram: 3.5,
        proteinByGram: 0.1,
        carbsByGram: 0.7,
        fatByGram: 0.02,
      );

      expect(ingredient.calories, 700);
      expect(ingredient.protein, 20);
      expect(ingredient.carbs, closeTo(140, 0.001));
    });
  });
}
