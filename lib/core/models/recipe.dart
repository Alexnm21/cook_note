import '../enums/difficulty.dart';
import '../enums/occasion.dart';
import 'ingredient.dart';

class Recipe {
  final String id;
  final String name;
  final String? image;
  final String? description;
  final List<Ingredient> ingredients;
  final List<String> steps;
  final Difficulty? difficulty;
  final int? time;
  final List<Occasion> occasion;
  final int portions;

  Recipe({
    required this.id,
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
    return Recipe(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      description: map['description'],
      ingredients: List<Ingredient>.from(
          map['ingredients'].map((e) => Ingredient.fromMap(e))),
      steps: List<String>.from(map['steps']),
      difficulty: map['difficulty'] != null
          ? Difficulty.values.firstWhere(
              (e) => e.toString() == 'Difficulty.${map['difficulty']}')
          : null,
      time: map['time'],
      occasion: (map['occasion'] as List)
          .map((e) =>
              Occasion.values.firstWhere((o) => o.toString() == 'Occasion.$e'))
          .toList(),
      portions: map['portions'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
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
  final String? id;
  final String? name;
  final String? image;
  final String? description;
  final List<Ingredient>? ingredients;
  final List<String>? steps;
  final Difficulty? difficulty;
  final int? time;
  final List<Occasion>? occasion;
  final int? portions;

  RecipeDto({
    this.id,
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

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    if (id != null) map['id'] = id;
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
}
