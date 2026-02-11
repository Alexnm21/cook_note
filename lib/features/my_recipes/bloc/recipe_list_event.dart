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

class FilterOccasions extends RecipeListEvent {
  final Set<Occasion> filterOccasions;
  FilterOccasions({required this.filterOccasions});
}

class SetLoading extends RecipeListEvent {
  final bool isLoading;
  SetLoading({required this.isLoading});
}
