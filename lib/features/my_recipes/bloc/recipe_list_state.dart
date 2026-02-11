part of 'recipe_list_bloc.dart';

class RecipeListState {
  final bool isLoading;
  final List<Recipe> recipes;
  final String searchText;
  final Set<Occasion> filterOccasions;

  RecipeListState({
    this.isLoading = true,
    required this.recipes,
    this.searchText = '',
    this.filterOccasions = const {},
  });

  // Getter que calcula las recetas filtradas dinámicamente
  List<Recipe> get filteredRecipes {
    if (searchText.isEmpty && filterOccasions.isEmpty) {
      return recipes;
    }
    return recipes
        .where((recipe) =>
            recipe.name.toLowerCase().contains(searchText.toLowerCase()))
        .where((recipe) =>
            filterOccasions.isEmpty ||
            recipe.occasions
                .any((occasion) => filterOccasions.contains(occasion)))
        .toList();
  }

  RecipeListState copyWith({
    bool? isLoading,
    List<Recipe>? recipes,
    String? searchText,
    Set<Occasion>? filterOccasions,
  }) {
    return RecipeListState(
      isLoading: isLoading ?? this.isLoading,
      recipes: recipes ?? this.recipes,
      searchText: searchText ?? this.searchText,
      filterOccasions: filterOccasions ?? this.filterOccasions,
    );
  }
}
