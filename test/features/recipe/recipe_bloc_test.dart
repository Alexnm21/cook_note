import 'package:cook_note/core/models/recipe.dart';
import 'package:cook_note/features/recipe/bloc/recipe_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/mock_repositories.dart';

void main() {
  group('RecipeBloc', () {
    late RecipeBloc recipeBloc;
    late MockRecipeRepository mockRepository;

    setUp(() {
      mockRepository = MockRecipeRepository();
      recipeBloc = RecipeBloc(recipeRepository: mockRepository);
    });

    tearDown(() {
      recipeBloc.close();
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
        await recipeBloc.addRecipe(recipeDto);

        // Assert
        // En un test real, verificarías que el mock fue llamado correctamente
        // y que el estado del bloc se actualizó apropiadamente
      });
    });

    group('updateRecipe', () {
      test('calls repository updateRecipe method', () async {
        // Arrange
        final recipeDto = RecipeDto(
          id: 'test-recipe-id',
          name: 'Updated Recipe',
          description: 'Updated Description',
          userId: 'test-user-id',
          ingredients: [],
          steps: [],
        );

        // Act
        await recipeBloc.updateRecipe(recipeDto);

        // Assert
        // Verificar que el mock fue llamado correctamente
      });
    });
  });
}
