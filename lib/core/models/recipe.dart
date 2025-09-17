import 'dart:convert';

import '../enums/difficulty.dart';
import '../enums/occasion.dart';
import 'ingredient.dart';

class Recipe {
  final String id;
  final String userId;
  final String name;
  final String? description;
  final List<Ingredient> ingredients;
  final List<String> steps;
  final Difficulty? difficulty;
  final int? time;
  final List<Occasion> occasion;
  final int portions;
  String? image;

  Recipe({
    required this.id,
    required this.userId,
    required this.name,
    this.image,
    this.description,
    required this.ingredients,
    required this.steps,
    this.difficulty,
    this.time,
    required this.occasion,
    required this.portions,
  });

  factory Recipe.fromMap(Map<String, dynamic> map) {
    List<dynamic> ingredients = jsonDecode(map['ingredients']);
    List<dynamic> steps = map['steps'];
    List<dynamic> occasion = map['occasion'];
    return Recipe(
      id: map['id'],
      userId: map['user_id'],
      name: map['name'],
      image: map['image'],
      description: map['description'],
      ingredients: (ingredients)
          .map((e) => Ingredient.fromMap(e as Map<String, dynamic>))
          .toList(),
      steps: steps.map((e) => e as String).toList(),
      difficulty: map['difficulty'] != null
          ? Difficulty.values.firstWhere(
              (e) => e.toString() == 'Difficulty.${map['difficulty']}')
          : null,
      time: map['time'],
      occasion: occasion
          .map((e) => Occasion.values
              .firstWhere((o) => o.name.toString() == '$e'.toLowerCase()))
          .toList(),
      portions: map['portions'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'image': image,
      'description': description,
      'ingredients': ingredients,
      'steps': steps,
      'difficulty': difficulty?.toString().split('.').last,
      'time': time,
      'occasion': occasion.map((e) => e.toString().split('.').last).toList(),
      'portions': portions,
    };
  }
}

class RecipeDto {
  String? id;
  String? userId;
  String? name;
  String? image;
  String? description;
  List<Ingredient>? ingredients;
  List<String>? steps;
  Difficulty? difficulty;
  int? time;
  List<Occasion>? occasion;
  int? portions;

  RecipeDto({
    this.id,
    this.userId,
    this.name,
    this.image,
    this.description,
    this.ingredients,
    this.steps,
    this.difficulty,
    this.time,
    this.occasion,
    this.portions,
  });

  factory RecipeDto.fromRecipe(Recipe recipe) {
    return RecipeDto(
      id: recipe.id,
      userId: recipe.userId,
      name: recipe.name,
      image: recipe.image,
      description: recipe.description,
      ingredients: recipe.ingredients,
      steps: recipe.steps,
      difficulty: recipe.difficulty,
      time: recipe.time,
      occasion: recipe.occasion,
      portions: recipe.portions,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    if (id != null) map['id'] = id;
    if (userId != null) map['userId'] = userId;
    if (name != null) map['name'] = name;
    if (image != null) map['image'] = image;
    if (description != null) map['description'] = description;
    if (ingredients != null) {
      map['ingredients'] = ingredients!.map((e) => e.toMap()).toList();
    }
    if (steps != null) map['steps'] = steps;
    if (difficulty != null) {
      map['difficulty'] = difficulty?.toString().split('.').last;
    }
    if (time != null) map['time'] = time;
    if (occasion != null) {
      map['occasion'] =
          occasion!.map((e) => e.toString().split('.').last).toList();
    }
    if (portions != null) map['portions'] = portions;

    return map;
  }

  Recipe toRecipe() {
    return Recipe.fromMap(toMap());
  }

  @override
  String toString() {
    return 'RecipeDto{id: $id,\n name: $name,\n image: $image,\n description: $description,\n ingredients: $ingredients,\n steps: $steps,\n difficulty: $difficulty,\n time: $time,\n occasion: $occasion,\n portions: $portions}';
  }
}
