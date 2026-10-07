import 'dart:convert';

import 'package:flutter_gemini/flutter_gemini.dart';

import '../enums/enums.dart';
import '../extensions/enum_extension.dart';
import '../models/ingredient.dart';

/// Service to calculate macronutrients using AI (Google Gemini)
///
/// This service uses the Google Gemini API (free tier) to calculate
/// the macros of a recipe based on its ingredients.
///
/// The returned macros are the TOTAL of the ingredient list as entered,
/// which is what gets stored in the database for `Recipe.portions`.
/// Serving counts are scaled later by `Recipe.addPortion`/`removePortion`.
///
/// Free tier limits:
/// - 60 requests per minute
/// - 1500 requests per day
class MacrosAIService {
  final Gemini _geminiClient = Gemini.instance;

  Future<Map<Macros, double>> calculateMacros(List<Ingredient> ingredients) async {
    final response = await _geminiClient.prompt(parts: [
      Part.text(
        // Ask the AI to calculate macros for the provided ingredients list in Spanish
        'Calcula los macros de las siguientes ingredientes: ${ingredients.map((e) => '${e.name} - ${e.grams}g').join(', ')}',
      ),
      Part.text(
        // Instruct to only return a JSON object with calories, protein, carbs, fat
        'Manda como resultado unicamente un objeto JSON {} con los siguientes campos: calories, protein, carbs, fat',
      ),
    ]);

    // Check if there is a valid response from Gemini
    if (response == null || response.output == null) {
      throw Exception('No response from Gemini');
    }

    // Clean the string by removing markdown code markers (like ```json ... ```)
    String jsonString = response.output!.trim();
    // Remove ```json or ``` at the start
    jsonString = jsonString.replaceFirst(RegExp(r'^```(?:json)?\s*'), '');
    // Remove ``` at the end
    jsonString = jsonString.replaceFirst(RegExp(r'\s*```$'), '');
    jsonString = jsonString.trim();

    // Parse the cleaned string into a Map
    final Object? decoded;
    try {
      decoded = jsonDecode(jsonString);
    } on FormatException catch (e) {
      throw Exception('Invalid JSON response from Gemini: ${e.message}');
    }

    if (decoded is! Map) {
      throw Exception('Unexpected JSON response from Gemini');
    }

    // Convert the parsed JSON Map to Map<Macros, double>
    final macrosMap = <Macros, double>{};
    for (final entry in decoded.entries) {
      final macro =
          EnumExtension.fromStringNullable('${entry.key}', Macros.values);
      if (macro == null || entry.value is! num) continue;
      macrosMap[macro] = (entry.value as num).toDouble();
    }

    if (macrosMap.isEmpty) {
      throw Exception('No macros found in the Gemini response');
    }

    return macrosMap;
  }
}
