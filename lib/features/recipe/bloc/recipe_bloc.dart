import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/recipe.dart';
import '../../../data/abstract/recipe_repository.dart';
import '../../../data/supabase/supabase_recipe_repository.dart';

part 'recipe_event.dart';
part 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRepository recipeRepository;

  RecipeBloc({RecipeRepository? recipeRepository})
      : recipeRepository =
            recipeRepository ?? SupabaseRecipeRepository.instance(),
        super(RecipeState()) {
    on<RecipeEvent>((event, emit) {});
  }

  addRecipe(RecipeDto recipe) async {
    await recipeRepository.addRecipe(recipe);
  }

  updateRecipe(RecipeDto recipe) async {
    await recipeRepository.updateRecipe(recipe);
  }
}
