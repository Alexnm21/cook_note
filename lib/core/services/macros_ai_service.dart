import 'dart:convert';

import 'package:flutter_gemini/flutter_gemini.dart';

import '../enums/enums.dart';
import '../models/ingredient.dart';

/// Service to calculate macronutrients using AI (Google Gemini)
///
/// This service uses the Google Gemini API (free tier) to calculate
/// the macros of a recipe based on its ingredients.
///
/// Free tier limits:
/// - 60 requests per minute
/// - 1500 requests per day
class MacrosAIService {
  final Gemini _geminiClient = Gemini.instance;

  Future<Map<Macros, double>> calculateMacros(List<Ingredient> ingredients,
      {int portions = 1}) async {
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
    final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;

    // Convert the parsed JSON Map to Map<Macros, double>
    final macrosMap = <Macros, double>{};
    for (final entry in jsonMap.entries) {
      final macro = MacrosExtension.fromString(entry.key);
      macrosMap[macro] = (entry.value as num).toDouble();
    }

    return macrosMap;
  }
}
