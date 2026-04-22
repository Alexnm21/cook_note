import 'package:flutter/material.dart';

import '../config/router/router.dart';
import '../config/theme/app_colors.dart';
import '../config/theme/styles/base_spaces.dart';
import '../config/theme/styles/base_text_style.dart';
import '../core/enums/macros.dart';
import '../core/models/recipe.dart';
import 'svg_icon.dart';
import 'url_image.dart';

class RecipeListTile extends StatelessWidget {
  final Recipe recipe;
  const RecipeListTile({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: paddings.y.s5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: UrlImage(
          imageUrl: recipe.image ?? '',
          aspectRatio: 1,
          borderRadius: BorderRadius.circular(15),
        ),
        onTap: () {
          router.pushNamed(Routes.recipe.name, extra: recipe);
        },
        title: Text(recipe.name,
            style: baseTextStyle.h3.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BasicInfo(
              recipe: recipe,
            ),
            spacings.y.s4,
            Row(
              children: [
                _MacrosChip(
                  macros: Macros.protein,
                  value: recipe.protein,
                ),
                _MacrosChip(
                  macros: Macros.carbs,
                  value: recipe.carbs,
                ),
                _MacrosChip(
                  macros: Macros.fat,
                  value: recipe.fat,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BasicInfo extends StatelessWidget {
  final Recipe recipe;
  const _BasicInfo({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SvgIcon(
          icon: "time",
          size: 14,
          color: AppColors.textLight,
        ),
        spacings.x.s2,
        Text('${recipe.time}',
            style: baseTextStyle.h4.copyWith(color: AppColors.textLight)),
        spacings.x.s8,
        const SvgIcon(
          icon: "calories",
          size: 16,
          color: AppColors.textLight,
        ),
        spacings.x.s2,
        Text('${recipe.calories.toInt()} kcal',
            style: baseTextStyle.h4.copyWith(color: AppColors.textLight)),
      ],
    );
  }
}

class _MacrosChip extends StatelessWidget {
  final Macros macros;
  final double value;
  const _MacrosChip({
    required this.macros,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: paddings.x.s2,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: macros.color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Text('${macros.text.characters.first.toUpperCase()}:',
              style: baseTextStyle.h4.copyWith(color: macros.color)),
          spacings.x.s2,
          Text('${value.toInt()}g',
              style: baseTextStyle.h4.copyWith(color: macros.color)),
        ],
      ),
    );
  }
}
