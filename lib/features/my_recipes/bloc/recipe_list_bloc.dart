import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/enums/occasion.dart';
import '../../../core/models/recipe.dart';
import '../../../data/abstract/recipe_repository.dart';
import '../../../data/supabase/supabase_recipe_repository.dart';

part 'recipe_list_event.dart';
part 'recipe_list_state.dart';

class RecipeListBloc extends Bloc<RecipeListEvent, RecipeListState> {
  final RecipeRepository recipeRepository;
  late final StreamSubscription<List<Recipe>> recipesStream;
  final String userId;

  RecipeListBloc({
    RecipeRepository? recipeRepository,
    required this.userId,
  })  : recipeRepository =
            recipeRepository ?? SupabaseRecipeRepository.instance(),
        super(RecipeListState(
          recipes: [],
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

    init();
  }

  init() async {
    //List<Recipe> recipes = await recipeRepository.getRecipes(userId);
    //add(SetRecipes(recipes: recipes));
    initStream();
  }

  initStream() {
    recipesStream = recipeRepository.getRecipesStream(userId).listen((recipes) {
      add(SetRecipes(recipes: recipes));
    });
  }

  getRecipes() async {
    add(SetLoading(isLoading: true));
    List<Recipe> recipes = await recipeRepository.getRecipes(userId);
    add(SetRecipes(recipes: recipes));
  }

  searchRecipes(String text) {
    add(SearchRecipes(searchText: text));
  }

  filterOccasion(Occasion? occasion) {
    Occasion? filterOccasion = state.filterOccasion;

    if (filterOccasion == occasion) {
      filterOccasion = null;
    } else {
      filterOccasion = occasion;
    }
    add(FilterOccasion(filterOccasion: filterOccasion));
  }

  @override
  Future<void> close() {
    recipesStream.cancel();
    return super.close();
  }
}
