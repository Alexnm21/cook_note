import 'package:cook_note/data/abstract/login_repository.dart';
import 'package:cook_note/data/abstract/recipe_repository.dart';

import '../mocks/mock_repositories.dart';

/// Helpers para configurar tests
///
/// Este archivo centraliza la configuración de mocks y helpers
/// para hacer los tests más consistentes y fáciles de mantener.

class TestHelpers {
  /// Crea un mock del LoginRepository
  static LoginRepository createMockLoginRepository() {
    return MockLoginRepository();
  }

  /// Crea un mock del RecipeRepository
  static RecipeRepository createMockRecipeRepository() {
    return MockRecipeRepository();
  }

  /// Configuración común para tests que requieren múltiples repositorios
  static ({
    LoginRepository loginRepository,
    RecipeRepository recipeRepository,
  }) createMockRepositories() {
    return (
      loginRepository: createMockLoginRepository(),
      recipeRepository: createMockRecipeRepository(),
    );
  }
}
