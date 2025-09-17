import 'package:cook_note/features/create_edit_recipe/view/recipe_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RecipeForm', () {
    testWidgets('renders RecipeForm correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: RecipeForm(),
        ),
      );
      // Verifica elementos básicos
      expect(find.text('Guardar Receta'), findsOneWidget);
      expect(find.byType(TextFormField), findsWidgets);
    });

    testWidgets('validates form fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: RecipeForm(),
        ),
      );

      await tester.tap(find.text('Guardar Receta'));
      await tester.pump();

      expect(
          find.text('Por favor ingresa el tiempo de cocción'), findsOneWidget);
    });
  });
}
