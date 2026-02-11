enum Difficulty { easy, medium, hard }

extension DifficultyExtension on Difficulty {
  static Difficulty? fromString(String? value) {
    if (value == null) return null;
    switch (value.toLowerCase()) {
      case 'easy':
        return Difficulty.easy;
      case 'medium':
        return Difficulty.medium;
      case 'hard':
        return Difficulty.hard;
      default:
        return null;
    }
  }
}
