import 'dart:async';

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

    on<FilterOccasions>((event, emit) {
      emit(state.copyWith(filterOccasions: event.filterOccasions));
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

  filterOccasion(Occasion occasion) {
    Set<Occasion> occasionSet = {...state.filterOccasions};
    if (occasionSet.contains(occasion)) {
      occasionSet.remove(occasion);
    } else {
      occasionSet.add(occasion);
    }
    add(FilterOccasions(filterOccasions: occasionSet));
  }

  @override
  Future<void> close() {
    recipesStream.cancel();
    return super.close();
  }
}
