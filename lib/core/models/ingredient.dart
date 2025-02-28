import '../enums/unit.dart';

class Ingredient {
  String name;
  int quantity;
  Unit unit;
  String? image;

  Ingredient({
    required this.name,
    required this.quantity,
    required this.unit,
    this.image,
  });

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      name: map['name'],
      quantity: map['quantity'],
      unit: Unit.values.byName(map['unit']),
      image: map['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'unit': unit.name,
      'image': image,
    };
  }
}
