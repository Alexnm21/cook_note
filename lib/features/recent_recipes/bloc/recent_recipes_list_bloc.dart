import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/recipe.dart';
import '../../../data/abstract/recent_recipes_repository.dart';
import '../../../data/hive/hive_recent_recipes_repository.dart';

part 'recent_recipes_list_event.dart';
part 'recent_recipes_list_state.dart';

class RecentRecipesListBloc
    extends Bloc<RecentRecipesListEvent, RecentRecipesListState> {
  final RecentRecipesRepository recentRecipesRepository;
  RecentRecipesListBloc({RecentRecipesRepository? recentRecipesRepository})
      : recentRecipesRepository =
            recentRecipesRepository ?? HiveRecentRecipesRepository(),
        super(RecentRecipesListState()) {
    on<SetRecentRecipes>((event, emit) {
      emit(state.copyWith(recipes: event.recipes));
    });

    init();
  }

  Future<void> init() async {
    List<Recipe> recentRecipes =
        await recentRecipesRepository.getRecentRecipes();
    add(SetRecentRecipes(recipes: recentRecipes));
  }
}
