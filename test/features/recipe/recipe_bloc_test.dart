import 'package:cook_note/core/blocs/user_bloc.dart';
import 'package:cook_note/core/models/recipe.dart';
import 'package:cook_note/features/recipe/bloc/recipe_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../mocks/mock_repositories.dart';

class TestUserBloc extends UserBloc {
  @override
  void init() {
    authSubscription = const Stream<AuthState>.empty().listen((_) {});
  }

  @override
  void listenAuthChanges() {}

  @override
  String getUserId() => 'test-user-id';
}

void main() {
  group('RecipeBloc', () {
    late RecipeBloc recipeBloc;
    late MockRecipeRepository mockRepository;
    late TestUserBloc userBloc;

    setUp(() {
      mockRepository = MockRecipeRepository();
      userBloc = TestUserBloc();
      recipeBloc =
          RecipeBloc(recipeRepository: mockRepository, userBloc: userBloc);
    });

    tearDown(() async {
      await recipeBloc.close();
      await userBloc.close();
    });

    test('initial state is RecipeState', () {
      expect(recipeBloc.state, isA<RecipeState>());
    });

    group('addRecipe', () {
      test('calls repository addRecipe method', () async {
        // Arrange
        final recipeDto = RecipeDto(
          name: 'Test Recipe',
          description: 'Test Description',
          userId: 'test-user-id',
          ingredients: [],
          steps: [],
        );

        // Act
        await expectLater(recipeBloc.addRecipe(recipeDto, null), completes);

        // Assert
        final recipes = await mockRepository.getRecipes('test-user-id');
        expect(recipes.length, 1);
        expect(recipes.first.name, 'Test Recipe');
      });
    });

    group('updateRecipe', () {
      test('actualiza la receta existente', () async {
        // Arrange
        final created = RecipeDto(
          name: 'Receta original',
          userId: 'test-user-id',
          ingredients: [],
          steps: [],
        );
        await recipeBloc.addRecipe(created, null);
        final stored = (await mockRepository.getRecipes('test-user-id')).first;

        final edited = RecipeDto.fromRecipe(stored)..name = 'Receta editada';

        // Act
        await expectLater(recipeBloc.updateRecipe(edited, null), completes);

        // Assert
        final recipes = await mockRepository.getRecipes('test-user-id');
        expect(recipes.length, 1);
        expect(recipes.first.name, 'Receta editada');
      });

      test('propaga deleteImage para borrar la imagen almacenada', () async {
        // Arrange
        final created = RecipeDto(
          name: 'Con imagen',
          image: 'imagen.png',
          userId: 'test-user-id',
          ingredients: [],
          steps: [],
        );
        await recipeBloc.addRecipe(created, null);

        final edited = RecipeDto.fromRecipe(
          (await mockRepository.getRecipes('test-user-id')).first,
        )..name = 'Sin imagen';

        // Act
        await recipeBloc.updateRecipe(edited, null, deleteImage: true);

        // Assert
        final recipes = await mockRepository.getRecipes('test-user-id');
        expect(recipes.first.name, 'Sin imagen');
        expect(recipes.first.image, isNull);
      });
    });

    group('deleteRecipe', () {
      test('elimina la receta del repositorio', () async {
        // Arrange
        await recipeBloc.addRecipe(
          RecipeDto(
            name: 'A eliminar',
            userId: 'test-user-id',
            ingredients: [],
            steps: [],
          ),
          null,
        );
        final recipes = await mockRepository.getRecipes('test-user-id');

        // Act
        await recipeBloc.deleteRecipe(recipes.first.id);

        // Assert
        expect(await mockRepository.getRecipes('test-user-id'), isEmpty);
      });
    });
  });
}
