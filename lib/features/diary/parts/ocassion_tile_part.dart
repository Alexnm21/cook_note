part of '../view/diary_view.dart';

class OcassionTilePart extends StatefulWidget {
  final Occasion occasion;
  final List<Recipe> recipes;
  const OcassionTilePart({
    super.key,
    required this.occasion,
    required this.recipes,
  });

  @override
  State<OcassionTilePart> createState() => _OcassionTilePartState();
}

class _OcassionTilePartState extends State<OcassionTilePart> {
  bool isExpanded = false;

  _onTap() {
    if (widget.recipes.isNotEmpty) {
      _expandList();
    } else {
      _showRecipeDialog();
    }
  }

  _showRecipeDialog() {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<RecipeListBloc>(),
        child: SingleSelectionRecipeDialog(
          occasion: widget.occasion,
          onSelected: (selectedRecipe) {
            context.read<ProfileBloc>().addMeal(
                  DailyMealEntry(
                    occasion: widget.occasion,
                    recipe: selectedRecipe,
                  ),
                );
          },
        ),
      ),
    );
  }

  _expandList() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  int _getTotalCalories() {
    return widget.recipes
        .fold(0, (sum, recipe) => sum + recipe.calories.round());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: paddings.top.s16,
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(BaseRadius.m),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(BaseRadius.s),
                ),
                padding: paddings.all.s8,
                child: SvgIcon(
                  icon: widget.occasion.name,
                  color: Colors.white,
                ),
              ),
              title: Text(
                'recipe.occasion.${widget.occasion.name}'.tr(),
                style: baseTextStyle.h3,
              ),
              subtitle: widget.recipes.isNotEmpty
                  ? Text('${_getTotalCalories()} kcal')
                  : null,
              trailing: widget.recipes.isNotEmpty
                  ? Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                    )
                  : const Icon(
                      Icons.add,
                    ),
            ),
            if (isExpanded && widget.recipes.isNotEmpty)
              Flexible(
                fit: FlexFit.loose,
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: paddings.all.s16,
                  itemBuilder: (context, index) => _RecipeItem(
                      recipe: widget.recipes[index], occasion: widget.occasion),
                  itemCount: widget.recipes.length,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _RecipeItem extends StatelessWidget {
  final Recipe recipe;
  final Occasion occasion;
  const _RecipeItem({required this.recipe, required this.occasion});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('${occasion.name}-${recipe.id}'),
      background: Container(
        alignment: Alignment.centerLeft,
        child: const Icon(
          Icons.delete,
          color: AppColors.primary,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.keyboard_arrow_right_rounded,
              size: sizes.s24, color: AppColors.primary),
          Text('${recipe.name}(${recipe.calories.toString()} kcal)'),
        ],
      ),
      onDismissed: (direction) {
        context.read<ProfileBloc>().removeMeal(occasion, recipe.id);
      },
    );
  }
}
