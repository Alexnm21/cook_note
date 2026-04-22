part of 'recipe_list_bloc.dart';

class RecipeListState {
  final bool isLoading;
  final List<Recipe> recipes;
  final List<Recipe> recentRecipes;
  final String searchText;
  final Occasion? filterOccasion;

  RecipeListState({
    this.isLoading = true,
    required this.recipes,
    required this.recentRecipes,
    this.searchText = '',
    this.filterOccasion,
  });

  // Getter que calcula las recetas filtradas dinámicamente
  List<Recipe> get filteredRecipes {
    if (searchText.isEmpty && filterOccasion == null) {
      return recipes;
    }
    return recipes
        .where((recipe) =>
            recipe.name.toLowerCase().contains(searchText.toLowerCase()))
        .where((recipe) =>
            filterOccasion == null || recipe.occasions.contains(filterOccasion))
        .toList();
  }

  List<Recipe> get filteredRecentRecipes {
    if (searchText.isEmpty && filterOccasion == null) {
      return recentRecipes;
    }
    return recentRecipes
        .where((recipe) =>
            recipe.name.toLowerCase().contains(searchText.toLowerCase()))
        .where((recipe) =>
            filterOccasion == null || recipe.occasions.contains(filterOccasion))
        .toList();
  }

  RecipeListState copyWith({
    bool? isLoading,
    List<Recipe>? recipes,
    List<Recipe>? recentRecipes,
    String? searchText,
    ValueGetter<Occasion?>? filterOccasion,
  }) {
    return RecipeListState(
      isLoading: isLoading ?? this.isLoading,
      recipes: recipes ?? this.recipes,
      recentRecipes: recentRecipes ?? this.recentRecipes,
      searchText: searchText ?? this.searchText,
      filterOccasion:
          filterOccasion != null ? filterOccasion() : this.filterOccasion,
    );
  }
}
