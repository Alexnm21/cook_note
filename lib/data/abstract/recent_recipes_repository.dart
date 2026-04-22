import '../../core/models/recipe.dart';

abstract class RecentRecipesRepository {
  Future<List<Recipe>> getRecentRecipes();
  Future<void> saveRecentRecipe(Recipe recipe);
}
