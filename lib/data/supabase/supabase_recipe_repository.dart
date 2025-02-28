import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/models/recipe.dart';
import '../abstract/recipe_repository.dart';

class SupabaseRecipeRepository implements RecipeRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Future<void> addRecipe(Recipe recipe) async {
    await supabase.from('recipes').insert(recipe.toMap());
  }

  @override
  Future<List<Recipe>> getRecipes(String userId) async {
    final response = await supabase
        .from('recipes')
        .select('*')
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return response.map((json) => Recipe.fromMap(json)).toList();
  }

  @override
  Future<void> updateRecipe(Recipe recipe) async {
    await supabase.from('recipes').update(recipe.toMap()).eq('id', recipe.id);
  }

  @override
  Future<void> deleteRecipe(String id) async {
    await supabase.from('recipes').delete().eq('id', id);
  }
}
