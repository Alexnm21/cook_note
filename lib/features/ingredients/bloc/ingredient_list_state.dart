// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'ingredient_list_bloc.dart';

class IngredientListState {
  final List<Ingredient> ingredients;

  IngredientListState({
    this.ingredients = const [],
  });

  IngredientListState copyWith({
    List<Ingredient>? ingredients,
  }) {
    return IngredientListState(
      ingredients: ingredients ?? this.ingredients,
    );
  }
}
