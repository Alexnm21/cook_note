part of 'recipe_list_bloc.dart';

abstract class RecipeListEvent {}

class SetRecipes extends RecipeListEvent {
  final List<Recipe> recipes;
  SetRecipes({required this.recipes});
}
