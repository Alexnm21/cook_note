import '../../core/models/recipe.dart';

abstract class RecipeRepository {
  Future<void> addRecipe(RecipeDto recipe);
  Future<List<Recipe>> getRecipes(String userId);
  Future<void> updateRecipe(RecipeDto recipe);
  Future<void> deleteRecipe(String id);
}
