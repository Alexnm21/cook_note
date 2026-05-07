// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../enums/difficulty.dart';
import '../enums/macros.dart';
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
  final List<Occasion> occasions;
  final int portions;
  final Map<Macros, double>? macros;
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
    required this.occasions,
    required this.portions,
    this.macros,
  });

  double get calories => macros?[Macros.calories] ?? 0;
  double get protein => macros?[Macros.protein] ?? 0;
  double get carbs => macros?[Macros.carbs] ?? 0;
  double get fat => macros?[Macros.fat] ?? 0;

  Recipe addPortion() {
    final factor = (portions + 1) / portions;
    return copyWith(
      portions: portions + 1,
      macros: macros?.map(
        (key, value) => MapEntry(
          key,
          value * factor,
        ),
      ),
      ingredients: ingredients
          .map(
            (ingredient) => Ingredient(
              name: ingredient.name,
              grams: (ingredient.grams * factor).round(),
              caloriesByGram: ingredient.caloriesByGram,
              proteinByGram: ingredient.proteinByGram,
              carbsByGram: ingredient.carbsByGram,
              fatByGram: ingredient.fatByGram,
              image: ingredient.image,
              unit: ingredient.unit,
            ),
          )
          .toList(),
    );
  }

  Recipe removePortion() {
    if (portions <= 1) {
      return this;
    }
    final factor = (portions - 1) / portions;
    return copyWith(
      portions: portions - 1,
      macros: macros?.map(
        (key, value) => MapEntry(
          key,
          value * factor,
        ),
      ),
      ingredients: ingredients
          .map(
            (ingredient) => Ingredient(
              name: ingredient.name,
              grams: (ingredient.grams * factor).round(),
              caloriesByGram: ingredient.caloriesByGram,
              proteinByGram: ingredient.proteinByGram,
              carbsByGram: ingredient.carbsByGram,
              fatByGram: ingredient.fatByGram,
              image: ingredient.image,
              unit: ingredient.unit,
            ),
          )
          .toList(),
    );
  }

  factory Recipe.fromMap(Map<dynamic, dynamic> map) {
    List<dynamic> ingredients = map['ingredients'] ?? [];
    List<dynamic> steps = map['steps'] ?? [];
    List<dynamic> occasion = map['occasion'] ?? [];

    Map<Macros, double>? macros;
    if (map['macros'] != null) {
      final macrosMap = Map<String, dynamic>.from(map['macros']);
      macros = macrosMap.map((key, value) => MapEntry(
            MacrosExtension.fromString(key),
            (value as num).toDouble(),
          ));
    }

    return Recipe(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      name: map['name'] ?? '',
      image: map['image'],
      description: map['description'],
      ingredients: (ingredients)
          .map((e) => Ingredient.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
      steps: steps.map((e) => e as String).toList(),
      difficulty: map['difficulty'] != null
          ? DifficultyExtension.fromString(map['difficulty'])
          : null,
      time: map['time'],
      occasions: occasion
          .map((e) => Occasion.values
              .firstWhere((o) => o.name.toString() == '$e'.toLowerCase()))
          .toList(),
      portions: map['portions'] ?? 1,
      macros: macros,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'image': image,
      'description': description,
      'ingredients': ingredients.map((e) => e.toMap()).toList(),
      'steps': steps,
      'difficulty': difficulty?.toString().split('.').last,
      'time': time,
      'occasion': occasions.map((e) => e.toString().split('.').last).toList(),
      'portions': portions,
      'macros': macros?.map((key, value) => MapEntry(key.name, value)),
    };
  }

  Recipe copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    List<Ingredient>? ingredients,
    List<String>? steps,
    Difficulty? difficulty,
    int? time,
    List<Occasion>? occasions,
    int? portions,
    Map<Macros, double>? macros,
    String? image,
  }) {
    return Recipe(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      difficulty: difficulty ?? this.difficulty,
      time: time ?? this.time,
      occasions: occasions ?? this.occasions,
      portions: portions ?? this.portions,
      macros: macros ?? this.macros,
      image: image ?? this.image,
    );
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
  Map<Macros, double>? macros;

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
    this.macros,
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
      occasion: recipe.occasions,
      portions: recipe.portions,
      macros: recipe.macros,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    if (id != null) map['id'] = id;
    if (userId != null) map['user_id'] = userId;
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
    if (macros != null) {
      map['macros'] = macros!.map((key, value) => MapEntry(key.name, value));
    }

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
