part of 'recipe_list_bloc.dart';

class RecipeListState {
  final List<Recipe> recipes;

  RecipeListState({required this.recipes});

  RecipeListState copyWith({
    List<Recipe>? recipes,
  }) {
    return RecipeListState(
      recipes: recipes ?? this.recipes,
    );
  }
}
