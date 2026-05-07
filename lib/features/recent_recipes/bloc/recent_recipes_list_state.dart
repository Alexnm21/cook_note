part of 'recent_recipes_list_bloc.dart';

class RecentRecipesListState {
  final List<Recipe> recipes;

  RecentRecipesListState({this.recipes = const []});

  RecentRecipesListState copyWith({
    List<Recipe>? recipes,
  }) {
    return RecentRecipesListState(
      recipes: recipes ?? this.recipes,
    );
  }
}
