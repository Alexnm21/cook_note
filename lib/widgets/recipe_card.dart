import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../config/router/router.dart';
import '../config/theme/app_colors.dart';
import '../config/theme/styles/base_spaces.dart';
import '../config/theme/styles/base_text_style.dart';
import '../core/models/recipe.dart';
import 'svg_icon.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        router.pushNamed(Routes.editRecipe.name, extra: recipe);
      },
      child: Card(
        margin: paddings.y.s12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                _Image(imageUrl: recipe.image!),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.2),
                        Colors.transparent,
                        Colors.transparent,
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  width: double.infinity,
                  height: 200,
                ),
                Positioned(
                    top: 10,
                    right: 15,
                    child: Row(
                      children: [
                        const SvgIcon(
                          icon: "time",
                          color: Colors.white,
                        ),
                        spacings.x.s2,
                        Text(
                          '${recipe.time}',
                          style: baseTextStyle.h3.copyWith(color: Colors.white),
                        ),
                        spacings.x.s8,
                        const SvgIcon(
                          icon: "ingredients",
                          color: Colors.white,
                        ),
                        spacings.x.s2,
                        Text(
                          '${recipe.ingredients.length}',
                          style: baseTextStyle.h3.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )),
              ],
            ),
            _Description(recipe: recipe),
          ],
        ),
      ),
    );
  }
}

class _Image extends StatelessWidget {
  final String imageUrl;
  const _Image({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: imageUrl.isEmpty
            ? Container(
                padding: paddings.all.s32,
                color: AppColors.primary,
                child: const SvgIcon(
                  icon: "food",
                  color: Colors.white,
                ),
              )
            : Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return const SvgIcon(icon: "error");
                },
              ),
      ),
    );
  }
}

class _Description extends StatelessWidget {
  final Recipe recipe;
  const _Description({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            recipe.name,
            style: baseTextStyle.h3.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(recipe.occasion.first.name, style: baseTextStyle.h3),
          if (recipe.time != null)
            Text(
              '${recipe.time} ${'core.minutes'.tr().toLowerCase()}',
              style: baseTextStyle.h3,
            ),
        ],
      ),
    );
  }
}
