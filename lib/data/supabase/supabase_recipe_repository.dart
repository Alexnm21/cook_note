import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/enums/supabase_names.dart';
import '../../core/models/recipe.dart';
import '../abstract/recipe_repository.dart';

class SupabaseRecipeRepository implements RecipeRepository {
  static SupabaseRecipeRepository? _instance;

  final SupabaseClient supabase = Supabase.instance.client;
  final String tableName = SupabaseNames.recipes.name;
  final String bucketName = SupabaseNames.recipeImages.name;

  // Constructor privado para el singleton
  SupabaseRecipeRepository._internal();

  /// Método factory que retorna la instancia única del repositorio
  factory SupabaseRecipeRepository.instance() {
    _instance ??= SupabaseRecipeRepository._internal();
    return _instance!;
  }

  @override
  Future<void> addRecipe(RecipeDto recipe, {File? imageFile}) async {
    if (imageFile != null) {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
      await supabase.storage.from(bucketName).upload(fileName, imageFile);
    }

    final recipeMap = recipe.toMap();

    await supabase.from(tableName).insert(recipeMap);
  }

  @override
  Future<List<Recipe>> getRecipes(String userId) async {
    final response = await supabase.from(tableName).select();

    final storage = supabase.storage.from(bucketName);

    return response.map((json) {
      final recipe = Recipe.fromMap(json);

      if (recipe.image != null && recipe.image!.isNotEmpty) {
        recipe.image = storage.getPublicUrl(recipe.image!);
      }
      return recipe;
    }).toList();
  }

  @override
  Future<void> updateRecipe(RecipeDto recipe) async {
    if (recipe.id == null) {
      throw Exception('Recipe ID is null');
    }
    await supabase.from(tableName).update(recipe.toMap()).eq('id', recipe.id!);
  }

  @override
  Future<void> deleteRecipe(String id) async {
    await supabase.from(tableName).delete().eq('id', id);
  }
}
