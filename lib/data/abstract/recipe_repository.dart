import '../../core/models/recipe.dart';

abstract class RecipeRepository {
  Future<void> addRecipe(Recipe recipe);
  Future<List<Recipe>> getRecipes(String userId);
  Future<void> updateRecipe(Recipe recipe);
  Future<void> deleteRecipe(String id);
}
