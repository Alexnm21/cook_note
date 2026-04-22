part of 'recipe_list_bloc.dart';

abstract class RecipeListEvent {}

class SetRecipes extends RecipeListEvent {
  final List<Recipe> recipes;
  SetRecipes({required this.recipes});
}

class SearchRecipes extends RecipeListEvent {
  final String searchText;
  SearchRecipes({required this.searchText});
}

class FilterOccasion extends RecipeListEvent {
  final Occasion? filterOccasion;
  FilterOccasion({required this.filterOccasion});
}

class SetLoading extends RecipeListEvent {
  final bool isLoading;
  SetLoading({required this.isLoading});
}

class SetRecentRecipes extends RecipeListEvent {
  final List<Recipe> recentRecipes;
  SetRecentRecipes({required this.recentRecipes});
}
