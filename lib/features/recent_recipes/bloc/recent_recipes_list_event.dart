part of 'recent_recipes_list_bloc.dart';

abstract class RecentRecipesListEvent {}

class SetRecentRecipes extends RecentRecipesListEvent {
  final List<Recipe> recipes;

  SetRecentRecipes({required this.recipes});
}
