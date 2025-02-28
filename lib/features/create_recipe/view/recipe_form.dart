import 'dart:developer' as developer;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/enums/unit.dart';
import '../../../core/models/ingredient.dart';
import '../../../core/models/recipe.dart';
import '../../../widgets/custom_input_text.dart';

part '../parts/ingredient_list_form_part.dart';

class RecipeForm extends StatefulWidget {
  const RecipeForm({super.key});

  @override
  RecipeFormState createState() => RecipeFormState();
}

class RecipeFormState extends State<RecipeForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _cookingTimeController;

  final List<Ingredient> ingredients = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _cookingTimeController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _cookingTimeController.dispose();
    super.dispose();
  }

  test() {
    developer.log('Title: ${_titleController.text}');
    developer.log('Description: ${_descriptionController.text}');
    developer.log('Cooking Time: ${_cookingTimeController.text}');
    developer.log('Ingredients: $ingredients');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home.addRecipe.title'.tr()),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // * TITLE
              CustomInputText(
                controller: _titleController,
                title: 'home.addRecipe.title'.tr(),
                icon: const Icon(Icons.title),
              ),
              const SizedBox(height: 16),

              // * DESCRIPTION
              CustomInputText(
                controller: _descriptionController,
                title: 'home.addRecipe.description'.tr(),
                icon: const Icon(Icons.description),
              ),

              const SizedBox(height: 16),

              // * TIME
              TextFormField(
                controller: _cookingTimeController,
                decoration: const InputDecoration(
                  labelText: 'Tiempo de cocción (minutos)',
                  prefixIcon: Icon(Icons.timer),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el tiempo de cocción';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor ingresa un número válido';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // * INGREDIENTS
              IngredientListFormPart(
                ingredients: ingredients,
              ),
              const SizedBox(height: 20),

              // * SAVE
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    RecipeDto recipe = RecipeDto(
                      id: _titleController.text,
                      name: _titleController.text,
                      description: _descriptionController.text,
                      time: int.parse(_cookingTimeController.text),
                      ingredients: ingredients,
                      steps: [],
                      occasion: [],
                      portions: 0,
                    );

                    developer.log('Recipe: $recipe');

                    // Mostrar mensaje de éxito
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('¡Receta guardada con éxito!'),
                      ),
                    );

                    // Opcional: regresar a la pantalla anterior
                    Navigator.pop(context);
                  }
                },
                child: const Text('Guardar Receta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
