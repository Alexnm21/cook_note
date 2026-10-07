part of '../view/recipe_view.dart';

class HeaderPart extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onDelete;
  final bool deleting;

  const HeaderPart({
    super.key,
    required this.recipe,
    required this.onDelete,
    this.deleting = false,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.width,
      pinned: true,
      leading: IconButton(
        onPressed: () {
          router.pop();
        },
        style: IconButton.styleFrom(
          backgroundColor: Colors.white,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(10),
        ),
        icon: const Icon(Icons.arrow_back, color: Colors.black),
      ),
      actions: [
        IconButton(
          onPressed: deleting ? null : onDelete,
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(10),
          ),
          icon: deleting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.delete_outline, color: AppColors.error),
        ),
        IconButton(
          onPressed: () => router.pushNamed(
            Routes.editRecipe.name,
            extra: recipe,
          ),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(10),
          ),
          icon: const Icon(Icons.edit, color: Colors.black),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: recipe.image?.isNotEmpty == true
            ? Image.network(
                recipe.image!,
                fit: BoxFit.cover,
              )
            : Container(
                padding: paddings.all.s32,
                color: AppColors.primary,
                child: const SvgIcon(
                  icon: "food",
                  color: Colors.white,
                ),
              ),
      ),
      title: const Text(''),
      backgroundColor: AppColors.secondary,
    );
  }
}
