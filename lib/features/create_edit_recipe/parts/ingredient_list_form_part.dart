// part of '../view/recipe_form.dart';

// class IngredientListFormPart extends StatefulWidget {
//   final List<Ingredient> ingredients;
//   const IngredientListFormPart({
//     super.key,
//     required this.ingredients,
//   });

//   @override
//   State<IngredientListFormPart> createState() => _IngredientListFormPartState();
// }

// class _IngredientListFormPartState extends State<IngredientListFormPart> {
//   final ScrollController _scrollController = ScrollController();

//   @override
//   Widget build(BuildContext context) {
//     return Flexible(
//       fit: FlexFit.loose,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             children: [
//               Text(
//                 'recipe.ingredients'.tr(),
//                 style: Theme.of(context).textTheme.titleMedium,
//               ),
//               Text(
//                 ' (*)',
//                 style: baseTextStyle.h2.copyWith(color: AppColors.primary),
//               ),
//             ],
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           if (widget.ingredients.isNotEmpty)
//             Flexible(
//               fit: FlexFit.loose,
//               child: ListView.builder(
//                 controller: _scrollController,
//                 itemCount: widget.ingredients.length,
//                 shrinkWrap: true,
//                 itemBuilder: (context, index) {
//                   return _IngredientRow(ingredient: widget.ingredients[index]);
//                 },
//               ),
//             ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                 onPressed: addRow,
//                 child: const Icon(Icons.add),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   addRow() {
//     widget.ingredients.add(Ingredient(
//         name: '',
//         grams: 0,
//         caloriesByGram: 0,
//         proteinByGram: 0,
//         carbsByGram: 0,
//         fatByGram: 0));

//     setState(() {});
//   }

//   scrollDown() {
//     if (widget.ingredients.isEmpty || !_scrollController.hasClients) return;
//     _scrollController.animateTo(
//       _scrollController.position.maxScrollExtent,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }
// }

// class _IngredientRow extends StatelessWidget {
//   final Ingredient ingredient;
//   const _IngredientRow({required this.ingredient});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           // * NAME
//           Expanded(
//             flex: 2,
//             child: TextFormField(
//               initialValue: ingredient.name,
//               decoration: InputDecoration(
//                 hintText: 'core.name'.tr(),
//               ),
//               onChanged: (value) {
//                 ingredient.name = value;
//               },
//             ),
//           ),
//           const SizedBox(width: 8),

//           // * QUANTITY
//           Expanded(
//             flex: 1,
//             child: TextFormField(
//               initialValue: ingredient.grams.toString(),
//               decoration: const InputDecoration(
//                 labelText: 'Cantidad',
//               ),
//               keyboardType: TextInputType.number,
//               onChanged: (value) {
//                 ingredient.grams = int.tryParse(value) ?? 0;
//               },
//             ),
//           ),
//           spacings.x.s8,

//           // * UNIT
//           Expanded(
//             flex: 2,
//             child: DropdownButtonFormField<Unit>(
//               value: ingredient,
//               decoration: const InputDecoration(
//                 labelText: 'Unidad',
//               ),
//               items: Unit.values.map((Unit unit) {
//                 return DropdownMenuItem<Unit>(
//                   value: unit,
//                   child: Text(unit.text),
//                 );
//               }).toList(),
//               onChanged: (Unit? newValue) {
//                 if (newValue != null) {
//                   ingredient.unit = newValue;
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
