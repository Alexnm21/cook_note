import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/styles/base_radius.dart';
import '../../../config/theme/styles/base_spaces.dart';
import '../../../config/theme/styles/base_text_style.dart';
import '../../../core/enums/macros.dart';
import '../../../core/enums/occasion.dart';
import '../../../core/extensions/datetime_extension.dart';
import '../../../core/models/daily_meal_entry.dart';
import '../../../core/models/diary_day.dart';
import '../../../core/models/recipe.dart';
import '../../../widgets/animated_progression_arc.dart';
import '../../../widgets/animated_progression_bar.dart';
import '../../../widgets/custom_selection_widget.dart';
import '../../../widgets/dialogs/single_selection_recipe_dialog.dart';
import '../../../widgets/svg_icon.dart';
import '../../my_recipes/bloc/recipe_list_bloc.dart';
import '../../profile/bloc/profile_bloc.dart';

part '../parts/date_selector_part.dart';
part '../parts/diary_switch.dart';
part '../parts/food_list_part.dart';
part '../parts/objective_part.dart';
part '../parts/ocassion_tile_part.dart';
part '../parts/welcome_part.dart';

class DiaryView extends StatefulWidget {
  const DiaryView({super.key});

  @override
  State<DiaryView> createState() => _DiaryViewState();
}

class _DiaryViewState extends State<DiaryView> {
  String selectedOption = 'home.diary.objective'.tr();

  @override
  initState() {
    super.initState();
    context.read<ProfileBloc>().setSelectedDate(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddings.all.s16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WelcomePart(),
          spacings.y.s16,
          DiarySwitch(
              selectedOption: selectedOption,
              onSelected: (option) {
                setState(() {
                  selectedOption = option;
                });
              }),
          spacings.y.s16,
          const DateSelectorPart(),
          Expanded(
            child: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
              if (state.loading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                );
              }
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: selectedOption == 'home.diary.objective'.tr()
                    ? const ObjectivePart()
                    : const FoodListPart(),
              );
            }),
          )
        ],
      ),
    );
  }
}
