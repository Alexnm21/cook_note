enum SupabaseNames {
  recipeImages('recipe-images'),
  recipes('recipes'),
  profiles('profiles'),
  diaryEntries('diary_entries'),
  weightRecords('weight_records');

  const SupabaseNames(this.name);

  final String name;
}
