import 'dart:io';

import 'package:cook_note/core/models/recipe.dart';
import 'package:cook_note/data/abstract/login_repository.dart';
import 'package:cook_note/data/abstract/recipe_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Implementaciones mock para testing
///
/// Estas implementaciones permiten hacer testing unitario sin depender
/// de servicios externos como Supabase.

class MockLoginRepository implements LoginRepository {
  @override
  Future<void> registerProfile({
    required String email,
    required String password,
    required String name,
  }) async {
    // Simular registro exitoso
    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  Future<User?> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    // Simular login exitoso
    await Future.delayed(const Duration(milliseconds: 100));
    return null;
  }

  @override
  Future<void> resetPasswordForEmail(String email) async {
    // Simular envío de recuperación exitoso
    await Future.delayed(const Duration(milliseconds: 100));
  }
}

class MockRecipeRepository implements RecipeRepository {
  final List<Recipe> _recipes = [];

  @override
  Future<List<Recipe>> getRecipes(String userId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _recipes.where((recipe) => recipe.userId == userId).toList();
  }

  @override
  Future<void> addRecipe(RecipeDto recipe, {File? imageFile}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _recipes.add(recipe.toRecipe());
  }

  @override
  Future<void> updateRecipe(RecipeDto recipe, {File? imageFile}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _recipes.indexWhere((r) => r.id == recipe.id);
    if (index != -1) {
      _recipes[index] = recipe.toRecipe();
    }
  }

  @override
  Future<void> deleteRecipe(String recipeId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _recipes.removeWhere((recipe) => recipe.id == recipeId);
  }

  @override
  Stream<List<Recipe>> getRecipesStream(String userId) {
    return Stream.value(
        _recipes.where((recipe) => recipe.userId == userId).toList());
  }
}
