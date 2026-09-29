import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../config/theme/app_colors.dart';
import '../features/weight/bloc/weight_bloc.dart';
import '../features/weight/view/weight_view.dart';

class WeightEvolutionPage extends StatelessWidget {
  const WeightEvolutionPage({
    super.key,
    required this.userId,
    this.targetWeight,
  });

  final String userId;
  final int? targetWeight;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('weight.title'.tr()),
      ),
      backgroundColor: AppColors.backgroundSecondary,
      body: BlocProvider(
        create: (context) => WeightBloc(
          userId: userId,
          targetWeight: targetWeight,
        ),
        child: const WeightView(),
      ),
    );
  }
}
