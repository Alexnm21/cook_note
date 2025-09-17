import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/recipe.dart';
import '../../../data/abstract/recipe_repository.dart';
import '../../../data/supabase/supabase_recipe_repository.dart';

part 'recipe_list_event.dart';
part 'recipe_list_state.dart';

class RecipeListBloc extends Bloc<RecipeListEvent, RecipeListState> {
  final RecipeRepository recipeRepository;
  final String userId;

  RecipeListBloc({
    RecipeRepository? recipeRepository,
    required this.userId,
  })  : recipeRepository =
            recipeRepository ?? SupabaseRecipeRepository.instance(),
        super(RecipeListState(recipes: [])) {
    on<SetRecipes>((event, emit) {
      emit(state.copyWith(recipes: event.recipes));
    });
    init();
  }

  init() async {
    List<Recipe> recipes = await recipeRepository.getRecipes(userId);
    add(SetRecipes(recipes: recipes));
  }
}
