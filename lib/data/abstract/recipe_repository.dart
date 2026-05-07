import 'dart:io';

import '../../core/models/recipe.dart';

abstract class RecipeRepository {
  Future<void> addRecipe(RecipeDto recipe, {File? imageFile});
  Future<List<Recipe>> getRecipes(String userId);
  Stream<List<Recipe>> getRecipesStream(String userId);
  Future<void> updateRecipe(RecipeDto recipe, {File? imageFile});
  Future<void> deleteRecipe(String id);
}
