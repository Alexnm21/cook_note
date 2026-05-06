import 'package:cook_note/features/create_edit_recipe/view/recipe_form.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  Future<void> pumpRecipeForm(WidgetTester tester) async {
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('es')],
        path: 'assets/translations',
        fallbackLocale: const Locale('es'),
        startLocale: const Locale('es'),
        child: Builder(
          builder: (context) => MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: const Scaffold(
              body: RecipeForm(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('RecipeForm', () {
    testWidgets('renders RecipeForm correctly', (WidgetTester tester) async {
      await pumpRecipeForm(tester);
      // Verifica elementos básicos
      expect(find.text('Guardar receta'), findsOneWidget);
      expect(find.byType(TextFormField), findsWidgets);
    });
  });
}
