part of '../view/recipe_form.dart';

class StepsListFormPart extends StatefulWidget {
  final RecipeDto recipe;
  const StepsListFormPart({super.key, required this.recipe});

  @override
  State<StepsListFormPart> createState() => _StepsListFormPartState();
}

class _StepsListFormPartState extends State<StepsListFormPart> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('recipe_form.steps'.tr(), style: baseTextStyle.h2),
          spacings.y.s10,
          if (widget.recipe.steps != null)
            ...widget.recipe.steps!.asMap().entries.map(
                  (entry) => _StepRow(
                    step: entry.value,
                    index: entry.key,
                    onDelete: () => deleteStep(entry.key),
                    onChanged: (value) {
                      widget.recipe.steps![entry.key] = value;
                    },
                  ),
                ),
          spacings.y.s10,
          GestureDetector(
            onTap: addStep,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: const Icon(Icons.add),
                ),
                spacings.x.s10,
                Text('recipe_form.add_step'.tr()),
              ],
            ),
          )
        ],
      ),
    );
  }

  addStep() {
    widget.recipe.steps ??= [];
    setState(() => widget.recipe.steps!.add(''));
  }

  deleteStep(int index) {
    widget.recipe.steps!.removeAt(index);
    setState(() {});
  }
}

class _StepRow extends StatelessWidget {
  final String step;
  final int index;
  final Function(String) onChanged;
  final Function() onDelete;
  const _StepRow({
    required this.step,
    required this.index,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Dismissible(
        key: Key('$index'),
        onDismissed: (direction) {
          onDelete();
        },
        direction: DismissDirection.startToEnd,
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                '$index',
                style: baseTextStyle.h3.copyWith(color: Colors.white),
              ),
            ),
            Expanded(
              child: TextFormField(
                initialValue: step,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                ),
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
