import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/styles/base_spaces.dart';
import '../../../config/theme/styles/base_text_style.dart';
import '../../../core/enums/difficulty.dart';
import '../../../core/enums/occasion.dart';
import '../../../core/models/ingredient.dart';
import '../../../core/models/recipe.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_input_text.dart';
import '../../../widgets/image_selector.dart';
import '../../recipe/bloc/recipe_bloc.dart';

part '../parts/difficulty_selector_part.dart';
part '../parts/occasion_selector_part.dart';
part '../parts/steps_list_form_part.dart';
part '../parts/time_form_part.dart';

class RecipeForm extends StatefulWidget {
  final Recipe? updateRecipe;
  const RecipeForm({super.key, this.updateRecipe});

  @override
  RecipeFormState createState() => RecipeFormState();
}

class RecipeFormState extends State<RecipeForm> {
  final _formKey = GlobalKey<FormState>();
  late RecipeDto recipe;
  File? imageFile;

  final List<Ingredient> ingredients = [];

  @override
  void initState() {
    if (widget.updateRecipe != null) {
      recipe = RecipeDto.fromRecipe(widget.updateRecipe!);
    } else {
      recipe = RecipeDto();
    }
    super.initState();
  }

  saveRecipe() {
    if (!_formKey.currentState!.validate()) return;

    if (recipe.id == null) {
      context.read<RecipeBloc>().addRecipe(recipe);
    } else {
      context.read<RecipeBloc>().updateRecipe(recipe);
    }
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
              initialValue: widget.updateRecipe?.name,
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
            ),

            spacings.y.s30,

            // * IMAGE
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('core.image'.tr(), style: baseTextStyle.h2),
                spacings.y.s10,
                ImageSelector(
                  imageFile: imageFile,
                  onChange: (file) {
                    setState(() => imageFile = file);
                  },
                  onRemove: () {
                    setState(() => imageFile = null);
                  },
                ),
              ],
            ),

            spacings.y.s30,

            // * DESCRIPTION
            CustomInputText(
              onChanged: (value) {
                recipe.description = value;
              },
              initialValue: widget.updateRecipe?.description,
              maxLines: 3,
              title: 'recipe_form.description'.tr(),
            ),

            spacings.y.s30,

            // * TIME
            TimeFormPart(
              time: recipe.time ?? 0,
              onChanged: (value) {
                setState(() {
                  recipe.time = value;
                });
              },
            ),

            spacings.y.s30,

            // * INGREDIENTS
            // IngredientListFormPart(
            //   ingredients: ingredients,
            // ),

            spacings.y.s30,

            // * STEPS
            StepsListFormPart(recipe: recipe),

            spacings.y.s30,

            // * DIFFICULTY
            DifficultySelectorPart(
              difficulty: recipe.difficulty,
              onChanged: (value) {
                setState(() {
                  recipe.difficulty = value;
                });
              },
            ),

            spacings.y.s30,

            // * OCCASION
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
