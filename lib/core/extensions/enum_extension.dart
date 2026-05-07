extension EnumExtension on Enum {
  /// Convierte un string a un valor del enum
  static T fromString<T extends Enum>(String value, List<T> values) {
    return values.firstWhere((e) => e.name == value);
  }

  /// Convierte un string nullable a un valor del enum nullable
  static T? fromStringNullable<T extends Enum>(String? value, List<T> values) {
    if (value == null) return null;
    try {
      return values.firstWhere((e) => e.name == value);
    } catch (e) {
      return null;
    }
  }
}
