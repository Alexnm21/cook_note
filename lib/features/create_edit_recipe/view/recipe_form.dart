import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/router/router.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/styles/base_spaces.dart';
import '../../../config/theme/styles/base_text_style.dart';
import '../../../core/enums/difficulty.dart';
import '../../../core/enums/macros.dart';
import '../../../core/enums/occasion.dart';
import '../../../core/enums/unit.dart';
import '../../../core/models/ingredient.dart';
import '../../../core/models/recipe.dart';
import '../../../core/services/macros_ai_service.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_input_text.dart';
import '../../../widgets/image_selector.dart';
import '../../recipe/bloc/recipe_bloc.dart';

part '../parts/difficulty_selector_part.dart';
part '../parts/ingredient_list_form_part.dart';
part '../parts/macros_form_part.dart';
part '../parts/occasion_selector_part.dart';
part '../parts/steps_list_form_part.dart';
part '../parts/value_modifier_part.dart';

class RecipeForm extends StatefulWidget {
  final Recipe? updateRecipe;
  final Function(Recipe)? onSave; // Only for add temporary new recipes
  const RecipeForm({super.key, this.updateRecipe, this.onSave});

  @override
  RecipeFormState createState() => RecipeFormState();
}

class RecipeFormState extends State<RecipeForm> {
  final _formKey = GlobalKey<FormState>();
  late bool isDialog;
  late RecipeDto recipe;
  File? imageFile;
  bool deleteImage = false;

  Map<Macros, double>? macros;

  @override
  void initState() {
    isDialog = widget.onSave != null;
    if (widget.updateRecipe != null) {
      recipe = RecipeDto.fromRecipe(widget.updateRecipe!);
      macros = widget.updateRecipe!.macros;
    } else {
      recipe = RecipeDto();
      recipe.ingredients = [];
      recipe.steps = [];
      recipe.occasion = [];
      macros = null;
    }

    super.initState();
  }

  saveRecipe() {
    if (!_formKey.currentState!.validate()) return;

    recipe.macros = macros;
    if (widget.onSave != null) {
      widget.onSave!(recipe.toRecipe());
      router.pop();
      return;
    }
    if (recipe.id == null) {
      context.read<RecipeBloc>().addRecipe(recipe, imageFile);
    } else {
      context.read<RecipeBloc>().updateRecipe(
            recipe,
            imageFile,
            deleteImage: deleteImage,
          );
    }

    router.goNamed('home');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // * TITLE
            CustomInputText(
              initialValue: recipe.name,
              onChanged: (value) {
                recipe.name = value;
              },
              title: 'recipe_form.title'.tr(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'recipe_form.required_field'.tr();
                }
                return null;
              },
              hint: 'recipe_form.title_hint'.tr(),
            ),

            spacings.y.s30,

            // * IMAGE,
            if (!isDialog)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('core.image'.tr(), style: baseTextStyle.h2),
                  spacings.y.s10,
                  ImageSelector(
                    imageFile: imageFile,
                    imageUrl: recipe.image ?? '',
                    onChange: (file) {
                      setState(() {
                        imageFile = file;
                        deleteImage = false;
                      });
                    },
                    onRemove: () {
                      setState(() {
                        imageFile = null;
                        deleteImage = true;
                        recipe.image = null;
                      });
                    },
                  ),
                ],
              ),
            if (!isDialog) spacings.y.s30,

            CustomInputText(
              onChanged: (value) {
                recipe.description = value;
              },
              initialValue: widget.updateRecipe?.description,
              maxLines: 3,
              title: 'recipe_form.description'.tr(),
              hint: 'recipe_form.description_hint'.tr(),
            ),

            spacings.y.s30,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ValueModifierPart(
                  title: 'recipe.portions'.tr(),
                  value: recipe.portions ?? 1,
                  add: () {
                    setState(() {
                      recipe.portions = (recipe.portions ?? 1) + 1;
                    });
                  },
                  subtract: () {
                    if (recipe.portions! - 1 < 0) return;
                    setState(() {
                      recipe.portions = (recipe.portions ?? 1) - 1;
                    });
                  },
                ),
                ValueModifierPart(
                  title: 'recipe_form.time'.tr(),
                  value: recipe.time ?? 0,
                  add: () {
                    setState(() {
                      recipe.time = (recipe.time ?? 0) + 5;
                    });
                  },
                  subtract: () {
                    if (recipe.time! - 5 < 0) return;
                    setState(() {
                      recipe.time = (recipe.time ?? 0) - 5;
                    });
                  },
                ),
              ],
            ),

            spacings.y.s30,

            IngredientListFormPart(
              ingredients: recipe.ingredients!,
            ),

            spacings.y.s30,

            MacrosFormPart(
              macros: macros,
              ingredients: recipe.ingredients ?? [],
              onChanged: (value) {
                setState(() {
                  macros = value;
                });
              },
            ),

            spacings.y.s30,

            // * STEPS
            StepsListFormPart(recipe: recipe),

            spacings.y.s30,

            DifficultySelectorPart(
              difficulty: recipe.difficulty,
              onChanged: (value) {
                setState(() {
                  recipe.difficulty = value;
                });
              },
            ),
            if (!isDialog) spacings.y.s30,
            if (!isDialog)
              OccasionSelectorPart(
                occasions: recipe.occasion ?? [],
                addOccasion: (value) {
                  recipe.occasion ??= [];
                  setState(() {
                    recipe.occasion?.add(value);
                  });
                },
                removeOccasion: (value) {
                  setState(() {
                    recipe.occasion?.remove(value);
                  });
                },
              ),
            spacings.y.s20,
            // * SAVE
            CustomButton.text(
              text: 'recipe_form.save'.tr(),
              textStyle: baseTextStyle.h2.copyWith(color: Colors.white),
              onPressed: saveRecipe,
            ),
          ],
        ),
      ),
    );
  }
}
