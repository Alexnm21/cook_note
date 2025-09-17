class Ingredient {
  final String name;
  int grams;
  final double caloriesByGram;
  final double proteinByGram;
  final double carbsByGram;
  final double fatByGram;
  final String? image;

  Ingredient({
    required this.name,
    required this.grams,
    this.caloriesByGram = 0,
    this.proteinByGram = 0,
    this.carbsByGram = 0,
    this.fatByGram = 0,
    this.image,
  });

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      name: map['name'],
      grams: int.parse(map['grams'] ?? '0'),
      caloriesByGram: double.parse(map['caloriesByGram'] ?? '0'),
      proteinByGram: double.parse(map['proteinByGram'] ?? '0'),
      carbsByGram: double.parse(map['carbsByGram'] ?? '0'),
      fatByGram: double.parse(map['fatByGram'] ?? '0'),
      image: map['image'],
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
    };
  }

  double get calories => grams * caloriesByGram;
  double get protein => grams * proteinByGram;
  double get carbs => grams * carbsByGram;
  double get fat => grams * fatByGram;
}
