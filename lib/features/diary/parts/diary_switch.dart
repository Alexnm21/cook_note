part of '../view/diary_view.dart';

class DiarySwitch extends StatelessWidget {
  final String selectedOption;
  final Function(String) onSelected;
  const DiarySwitch(
      {super.key, required this.selectedOption, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return CustomSelectionWidget(
      options: ['home.diary.objective'.tr(), 'home.diary.foods'.tr()],
      selectedOption: selectedOption,
      onSelected: onSelected,
    );
  }
}
