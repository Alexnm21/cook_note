import 'dart:developer';
import 'dart:io';

import '../../core/enums/supabase_names.dart';
import '../../core/models/recipe.dart';
import '../abstract/recipe_repository.dart';
import 'base_supabase_repository.dart';

class SupabaseRecipeRepository extends BaseSupabaseRepository
    implements RecipeRepository {
  static SupabaseRecipeRepository? _instance;

  final String bucketName = SupabaseNames.recipeImages.name;

  SupabaseRecipeRepository._internal() : super(SupabaseNames.recipes.name);

  /// Método factory que retorna la instancia única del repositorio
  factory SupabaseRecipeRepository.instance() {
    _instance ??= SupabaseRecipeRepository._internal();
    return _instance!;
  }

  @override
  Stream<List<Recipe>> getRecipesStream(String userId) {
    return supabase
        .from(tableName)
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .asyncMap(
          (event) async {
            final List<Recipe> recipes = [];
            for (final json in event) {
              Recipe recipe = Recipe.fromMap(json);
              if (recipe.image != null && recipe.image!.isNotEmpty) {
                final imageUrl = await _getImageUrl(recipe.image!);
                recipe.image = imageUrl;
              }
              recipes.add(recipe);
            }
            return recipes;
          },
        );
  }

  @override
  Future<void> addRecipe(RecipeDto recipe, {File? imageFile}) async {
    String? imageFileName;

    if (imageFile != null) {
      imageFileName =
          '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
      await supabase.storage.from(bucketName).upload(imageFileName, imageFile);
    }

    final recipeMap = recipe.toMap();

    if (imageFileName != null) {
      recipeMap['image'] = imageFileName;
    }

    await supabase.from(tableName).insert(recipeMap);
  }

  @override
  Future<List<Recipe>> getRecipes(String userId) async {
    final response =
        await supabase.from(tableName).select().eq('user_id', userId);

    final List<Recipe> recipes = [];

    for (final json in response) {
      final recipe = Recipe.fromMap(json);

      if (recipe.image != null && recipe.image!.isNotEmpty) {
        // Verificar si el archivo existe y obtener la URL
        final imageUrl = await _getImageUrl(recipe.image!);
        recipe.image = imageUrl;
      }

      recipes.add(recipe);
    }

    return recipes;
  }

  @override
  Future<void> updateRecipe(
    RecipeDto recipe, {
    File? imageFile,
    bool deleteImage = false,
  }) async {
    String? imageFileName;

    if (imageFile != null) {
      imageFileName =
          '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';

      try {
        // If there is already an image, try to update it
        if (recipe.image != null && recipe.image!.isNotEmpty) {
          // Check if the file exists before trying to update it
          final fileExists = await _fileExists(recipe.image!);
          if (fileExists) {
            await supabase.storage
                .from(bucketName)
                .update(recipe.image!, imageFile);
            imageFileName = recipe.image; // Keep the same name
          } else {
            // If it doesn't exist, upload as a new file
            await supabase.storage
                .from(bucketName)
                .upload(imageFileName, imageFile);
          }
        } else {
          // No previous image, upload as a new file
          await supabase.storage
              .from(bucketName)
              .upload(imageFileName, imageFile);
        }
      } catch (e) {
        // If updating fails, try uploading as a new file
        await supabase.storage
            .from(bucketName)
            .upload(imageFileName!, imageFile);
      }
    }

    if (deleteImage && imageFile == null) {
      if (recipe.image != null && recipe.image!.isNotEmpty) {
        try {
          await supabase.storage.from(bucketName).remove([recipe.image!]);
        } catch (e) {
          log('Error al eliminar imagen: $e');
        }
      }
    }

    if (recipe.id == null) {
      throw Exception('Recipe ID is null');
    }

    // Actualizar el mapa de la receta con el nuevo nombre de imagen si se subió una nueva
    final recipeMap = recipe.toMap();
    if (imageFileName != null) {
      recipeMap['image'] = imageFileName;
    } else if (deleteImage) {
      recipeMap['image'] = null;
    } else {
      recipeMap.remove('image');
    }

    await supabase.from(tableName).update(recipeMap).eq('id', recipe.id!);
  }

  @override
  Future<void> deleteRecipe(String id) async {
    final response =
        await supabase.from(tableName).delete().eq('id', id).select();

    if (response.isEmpty) return;

    final image = response.first['image'] as String?;

    if (image != null && image.isNotEmpty) {
      try {
        await supabase.storage.from(bucketName).remove([image]);
      } catch (e) {
        log('Error al eliminar la imagen de la receta: $e');
      }
    }
  }

  /// Verifica si un archivo existe en el storage
  Future<bool> _fileExists(String fileName) async {
    try {
      final storage = supabase.storage.from(bucketName);
      await storage.download(fileName);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Obtiene la URL pública de una imagen si existe
  Future<String?> _getImageUrl(String fileName) async {
    try {
      final exists = await _fileExists(fileName);
      if (exists) {
        final storage = supabase.storage.from(bucketName);
        return storage.getPublicUrl(fileName);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
