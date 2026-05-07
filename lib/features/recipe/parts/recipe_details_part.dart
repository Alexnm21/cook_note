part of '../view/recipe_view.dart';

class RecipeDetailsPart extends StatelessWidget {
  final Recipe recipe;
  final Function() onAddPortion;
  final Function() onRemovePortion;
  const RecipeDetailsPart({
    super.key,
    required this.recipe,
    required this.onAddPortion,
    required this.onRemovePortion,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddings.all.s16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _DetailItem(
            icon: 'time',
            label: 'recipe.time'.tr(),
            value: '${recipe.time} min',
          ),
          const _SeparationBar(),
          Row(
            children: [
              _PortionButton(
                onTap: onRemovePortion,
                icon: Icons.keyboard_arrow_left,
              ),
              _DetailItem(
                icon: 'people',
                label: 'recipe.portions'.tr(),
                value: '${recipe.portions}',
              ),
              _PortionButton(
                onTap: onAddPortion,
                icon: Icons.keyboard_arrow_right,
              ),
            ],
          ),
          const _SeparationBar(),
          _DetailItem(
            icon: 'star',
            label: 'recipe.difficulty.title'.tr(),
            value:
                'recipe.difficulty.${recipe.difficulty?.toString().split('.').last ?? ''}'
                    .tr(),
          ),
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgIcon(
          icon: icon,
          size: 24,
          color: AppColors.primary,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _SeparationBar extends StatelessWidget {
  const _SeparationBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: sizes.s1,
      height: sizes.s40,
      color: Colors.blueGrey,
    );
  }
}

class _PortionButton extends StatelessWidget {
  final Function() onTap;
  final IconData icon;
  const _PortionButton({required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: paddings.all.s6,
        child: Icon(
          icon,
          size: 20,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
