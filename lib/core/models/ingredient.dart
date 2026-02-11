import '../enums/unit.dart';

class Ingredient {
  String name;
  int grams;
  final double caloriesByGram;
  final double proteinByGram;
  final double carbsByGram;
  final double fatByGram;
  final String? image;
  Unit? unit;

  Ingredient({
    required this.name,
    required this.grams,
    this.caloriesByGram = 0,
    this.proteinByGram = 0,
    this.carbsByGram = 0,
    this.fatByGram = 0,
    this.image,
    this.unit,
  });

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      name: map['name'],
      grams: map['grams'] ?? 0,
      caloriesByGram: map['caloriesByGram'] ?? 0,
      proteinByGram: map['proteinByGram'] ?? 0,
      carbsByGram: map['carbsByGram'] ?? 0,
      fatByGram: map['fatByGram'] ?? 0,
      image: map['image'],
      unit: UnitExtension.fromString(map['unit']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'grams': grams,
      'caloriesByGram': caloriesByGram,
      'proteinByGram': proteinByGram,
      'carbsByGram': carbsByGram,
      'fatByGram': fatByGram,
      'image': image,
      'unit': unit?.toString().split('.').last,
    };
  }

  double get calories => grams * caloriesByGram;
  double get protein => grams * proteinByGram;
  double get carbs => grams * carbsByGram;
  double get fat => grams * fatByGram;
}
