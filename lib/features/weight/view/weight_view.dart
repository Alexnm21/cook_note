import 'dart:math';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/styles/base_radius.dart';
import '../../../config/theme/styles/base_spaces.dart';
import '../../../config/theme/styles/base_text_style.dart';
import '../../../core/extensions/datetime_extension.dart';
import '../../../core/models/weight_record.dart';
import '../../../widgets/animated_progression_bar.dart';
import '../../../widgets/cook_note_container.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_selection_widget.dart';
import '../../../widgets/svg_icon.dart';
import '../bloc/weight_bloc.dart';
import 'add_weight_dialog.dart';

part '../parts/weight_chart_part.dart';
part '../parts/weight_current_part.dart';
part '../parts/weight_history_part.dart';
part '../parts/weight_stats_part.dart';

class WeightView extends StatelessWidget {
  const WeightView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeightBloc, WeightState>(
      builder: (context, state) {
        if (state.loading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        if (state.records.isEmpty) {
          return _EmptyView(
            onAdd: () => _showAddWeightDialog(context),
          );
        }
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddWeightDialog(context),
            child: const Icon(Icons.add),
          ),
          body: SingleChildScrollView(
            padding: paddings.all.s16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const WeightCurrentPart(),
                spacings.y.s24,
                const WeightChartPart(),
                spacings.y.s24,
                const WeightStatsPart(),
                spacings.y.s24,
                Text('weight.history'.tr(), style: baseTextStyle.h2),
                spacings.y.s12,
                const WeightHistoryPart(),
                spacings.y.s16,
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showAddWeightDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => AddWeightDialog(
        onAdd: (weightKg, date) {
          context.read<WeightBloc>().addWeightRecord(
                WeightRecord(weightKg: weightKg, date: date),
              );
        },
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: paddings.all.s24,
      child: Column(
        children: [
          SvgIcon(icon: 'weight', size: sizes.s64, color: AppColors.primary),
          spacings.y.s16,
          Text(
            'weight.emptyTitle'.tr(),
            style: baseTextStyle.h1,
            textAlign: TextAlign.center,
          ),
          spacings.y.s8,
          Text(
            'weight.emptyBody'.tr(),
            style: baseTextStyle.body3.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          spacings.y.s24,
          SizedBox(
            width: double.infinity,
            child: CustomButton.text(
              text: 'weight.add'.tr(),
              textStyle: baseTextStyle.h3.copyWith(color: Colors.white),
              onPressed: onAdd,
            ),
          ),
        ],
      ),
    );
  }
}
