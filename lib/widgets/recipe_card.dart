import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../config/router/router.dart';
import '../config/theme/app_colors.dart';
import '../config/theme/styles/base_spaces.dart';
import '../config/theme/styles/base_text_style.dart';
import '../core/models/recipe.dart';
import 'svg_icon.dart';
import 'url_image.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final double? width;
  final double borderRadius = 30;
  const RecipeCard({super.key, required this.recipe, this.width});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        router.pushNamed(Routes.recipe.name, extra: recipe);
      },
      child: Container(
        margin: paddings.all.s10,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 4,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                UrlImage(
                  imageUrl: recipe.image ?? '',
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(borderRadius),
                    topRight: Radius.circular(borderRadius),
                  ),
                ),
                Positioned(
                    top: 10,
                    right: 15,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(
                            30,
                          )),
                      child: Row(
                        children: [
                          const SvgIcon(
                            icon: "time",
                            color: Colors.white,
                            size: 15,
                          ),
                          spacings.x.s2,
                          Text(
                            '${recipe.time} min',
                            style:
                                baseTextStyle.h4.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
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

class _Description extends StatelessWidget {
  final Recipe recipe;
  const _Description({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            recipe.name,
            style: baseTextStyle.h3.copyWith(
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            children: [
              // ...recipe.occasions.map(
              //   (occasion) => Text(
              //       '${'recipe.occasion.${occasion.name}'.tr()} ',
              //       style: _textStyle(),
              //       overflow: TextOverflow.ellipsis),
              // ),
              // spacings.x.s2,
              // Text('·', style: _textStyle()),
              // spacings.x.s2,
              // Text(
              //   '${recipe.calories} kcal',
              //   style: _textStyle(),
              //   overflow: TextOverflow.ellipsis,
              // ),
              Flexible(
                child: Text(
                  _getSubtitle(),
                  style: _textStyle(),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  TextStyle _textStyle() {
    return baseTextStyle.h3
        .copyWith(color: AppColors.textLight, fontWeight: FontWeight.w500);
  }

  String _getSubtitle() {
    String text = '${recipe.calories} kcal ';
    if (recipe.occasions.isEmpty) return text;
    text +=
        '(${recipe.occasions.map((occasion) => 'recipe.occasion.${occasion.name}'.tr()).join(', ')}) ';

    return text;
  }
}
