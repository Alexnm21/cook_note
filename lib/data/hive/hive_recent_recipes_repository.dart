import 'package:hive_flutter/hive_flutter.dart';

import '../../core/models/recipe.dart';
import '../abstract/recent_recipes_repository.dart';

class HiveRecentRecipesRepository implements RecentRecipesRepository {
  static const String _boxName = 'recent_recipes_box';
  Box? _box;
  final String key = 'recent_recipes';

  Future<void> init() async {
    _box ??= await Hive.openBox(_boxName);
  }

  @override
  Future<List<Recipe>> getRecentRecipes() async {
    await init();
    final data = _box!.get(key);
    if (data == null) return [];
    return (data as List<dynamic>).map((e) => Recipe.fromMap(e)).toList();
  }

  @override
  Future<void> saveRecentRecipe(Recipe recipe) async {
    await init();
    final recipes = await getRecentRecipes();

    /// Check if the recipe is already in the list
    /// If it is, remove it and then add it to the top
    recipes.removeWhere((r) => r.id == recipe.id);

    /// If the list is full, remove the last item
    if (recipes.length >= 20) {
      recipes.removeLast();
    }

    /// Add the recipe to the top
    recipes.insert(0, recipe);
    await _box!.put(key, recipes.map((e) => e.toMap()).toList());
  }
}
