import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/enums/occasion.dart';
import '../../../core/models/recipe.dart';
import '../../../data/abstract/recent_recipes_repository.dart';
import '../../../data/abstract/recipe_repository.dart';
import '../../../data/hive/hive_recent_recipes_repository.dart';
import '../../../data/supabase/supabase_recipe_repository.dart';

part 'recipe_list_event.dart';
part 'recipe_list_state.dart';

class RecipeListBloc extends Bloc<RecipeListEvent, RecipeListState> {
  final RecipeRepository recipeRepository;
  final RecentRecipesRepository recentRecipesRepository;
  late final StreamSubscription<List<Recipe>> recipesStream;
  final String userId;

  RecipeListBloc({
    RecipeRepository? recipeRepository,
    RecentRecipesRepository? recentRecipesRepository,
    required this.userId,
  })  : recipeRepository =
            recipeRepository ?? SupabaseRecipeRepository.instance(),
        recentRecipesRepository =
            recentRecipesRepository ?? HiveRecentRecipesRepository(),
        super(RecipeListState(
          recipes: [],
          recentRecipes: [],
        )) {
    on<SetRecipes>((event, emit) {
      emit(state.copyWith(recipes: event.recipes, isLoading: false));
    });

    on<SearchRecipes>((event, emit) {
      emit(state.copyWith(searchText: event.searchText));
    });

    on<FilterOccasion>((event, emit) {
      emit(state.copyWith(filterOccasion: () => event.filterOccasion));
    });

    on<SetRecentRecipes>((event, emit) {
      emit(state.copyWith(recentRecipes: event.recentRecipes));
    });

    init();
  }

  init() async {
    initStream();
    List<Recipe> recentRecipes =
        await recentRecipesRepository.getRecentRecipes();
    add(SetRecentRecipes(recentRecipes: recentRecipes));
  }

  initStream() {
    recipesStream = recipeRepository.getRecipesStream(userId).listen((recipes) {
      add(SetRecipes(recipes: recipes));
    });
  }

  void searchRecipes(String text) {
    add(SearchRecipes(searchText: text));
  }

  void filterOccasion(Occasion? occasion) {
    Occasion? filterOccasion = state.filterOccasion;

    if (filterOccasion == occasion) {
      filterOccasion = null;
    } else {
      filterOccasion = occasion;
    }
    add(FilterOccasion(filterOccasion: filterOccasion));
  }

  Future<void> addToRecentRecipes(Recipe recipe) async {
    await recentRecipesRepository.saveRecentRecipe(recipe);
    final recentRecipes = await recentRecipesRepository.getRecentRecipes();
    add(SetRecentRecipes(recentRecipes: recentRecipes));
  }

  @override
  Future<void> close() {
    recipesStream.cancel();
    return super.close();
  }
}
