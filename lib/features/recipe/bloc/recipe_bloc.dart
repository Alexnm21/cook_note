import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/blocs/user_bloc.dart';
import '../../../core/models/recipe.dart';
import '../../../data/abstract/recipe_repository.dart';
import '../../../data/supabase/supabase_recipe_repository.dart';

part 'recipe_event.dart';
part 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRepository recipeRepository;
  final UserBloc userBloc;

  RecipeBloc({
    RecipeRepository? recipeRepository,
    required this.userBloc,
  })  : recipeRepository =
            recipeRepository ?? SupabaseRecipeRepository.instance(),
        super(RecipeState()) {
    on<RecipeEvent>((event, emit) {});
  }

  addRecipe(RecipeDto recipe, File? imageFile) async {
    final uid = userBloc.getUserId();

    recipe.userId = uid;
    await recipeRepository.addRecipe(recipe, imageFile: imageFile);
  }

  updateRecipe(RecipeDto recipe, File? imageFile, {bool deleteImage = false}) async {
    await recipeRepository.updateRecipe(
      recipe,
      imageFile: imageFile,
      deleteImage: deleteImage,
    );
  }

  deleteRecipe(String id) async {
    await recipeRepository.deleteRecipe(id);
  }
}
