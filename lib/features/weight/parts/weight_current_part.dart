part of '../view/weight_view.dart';

class WeightCurrentPart extends StatelessWidget {
  const WeightCurrentPart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeightBloc, WeightState>(
      builder: (context, state) {
        return CookNoteContainer(
          borderRadius: 48,
          padding: paddings.all.s24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'weight.current'.tr().toUpperCase(),
                    style: baseTextStyle.h3.copyWith(
                        color: AppColors.textLight,
                        fontWeight: FontWeight.w600),
                  ),
                  CookNoteContainer(
                    hasShadow: false,
                    borderRadius: 99,
                    padding: EdgeInsetsGeometry.symmetric(
                        horizontal: sizes.s10, vertical: sizes.s4),
                    backgroundColor: AppColors.chipColor,
                    child: Row(
                      children: [
                        const SvgIcon(
                            icon: 'calendar', color: AppColors.textLight),
                        spacings.x.s6,
                        Text(
                          '${state.currentRecord?.date.day} ${state.currentRecord?.date.monthShortName ?? ''}',
                          style: baseTextStyle.h3
                              .copyWith(color: AppColors.textLight),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              spacings.y.s16,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    (state.lastWeight ?? 0).toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    ' kg',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  if (state.recentChange != null && state.recentChange != 0)
                    _ChangeBadge(change: state.recentChange!),
                ],
              ),
              if (state.goalProgress != null) ...[
                spacings.y.s16,
                _GoalProgressRow(state: state),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _ChangeBadge extends StatelessWidget {
  const _ChangeBadge({required this.change});

  final double change;

  @override
  Widget build(BuildContext context) {
    final isLoss = change < 0;
    final color = isLoss ? Colors.green : AppColors.error;
    return CookNoteContainer(
      padding: EdgeInsets.symmetric(horizontal: sizes.s10, vertical: sizes.s4),
      borderRadius: BaseRadius.circle,
      backgroundColor: color.withValues(alpha: 0.15),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isLoss ? Icons.arrow_drop_down : Icons.arrow_drop_up,
              color: color),
          Text(
            '${change.abs().toStringAsFixed(1)} kg',
            style: baseTextStyle.h6.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _GoalProgressRow extends StatelessWidget {
  const _GoalProgressRow({required this.state});

  final WeightState state;

  @override
  Widget build(BuildContext context) {
    final current = state.lastWeight ?? 0;
    final remaining =
        (current - state.targetWeight!).clamp(0.0, double.infinity).toDouble();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.flag, size: 16, color: AppColors.primary),
                spacings.x.s4,
                Text('weight.progress'.tr(), style: baseTextStyle.h6),
              ],
            ),
            Text('weight.remaining'.tr(args: [remaining.toStringAsFixed(1)]),
                style: baseTextStyle.h6),
          ],
        ),
        spacings.y.s8,
        LayoutBuilder(
          builder: (context, constraints) {
            return AnimatedProgressionBar(
              progress: state.goalProgress!,
              width: constraints.maxWidth,
              height: 12,
              color: AppColors.primary,
              backgroundColor: AppColors.secondary,
            );
          },
        ),
      ],
    );
  }
}
