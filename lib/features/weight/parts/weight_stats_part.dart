part of '../view/weight_view.dart';

class WeightStatsPart extends StatelessWidget {
  const WeightStatsPart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeightBloc, WeightState>(
      builder: (context, state) {
        return IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: _StatChip(
                  label: 'weight.min'.tr(),
                  unit: 'weight.kg'.tr(),
                  value: state.minWeight?.toStringAsFixed(1) ?? '—',
                ),
              ),
              spacings.x.s8,
              Expanded(
                child: _StatChip(
                  label: 'weight.max'.tr(),
                  unit: 'weight.kg'.tr(),
                  value: state.maxWeight?.toStringAsFixed(1) ?? '—',
                ),
              ),
              spacings.x.s8,
              Expanded(child: _buildRateChip(state)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRateChip(WeightState state) {
    final rate = state.weeklyLossRate;
    String value;
    String? subLabel;
    Color? subColor;

    if (rate == null) {
      value = '—';
      subLabel = 'weight.noLoss'.tr();
    } else if (rate <= 0) {
      value = rate.toStringAsFixed(1);
      subLabel = 'weight.noLoss'.tr();
    } else {
      value = '-${rate.toStringAsFixed(1)}';
      subLabel =
          state.isHealthyLoss ? 'weight.healthy'.tr() : 'weight.fastRate'.tr();
      subColor = state.isHealthyLoss ? Colors.green : AppColors.error;
    }

    return _StatChip(
      label: 'weight.rate'.tr(),
      value: value,
      unit: 'weight.rateWeek'.tr(),
      subLabel: subLabel,
      subColor: subColor,
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
    required this.unit,
    this.subLabel,
    this.subColor,
  });

  final String label;
  final String value;
  final String unit;
  final String? subLabel;
  final Color? subColor;

  @override
  Widget build(BuildContext context) {
    return CookNoteContainer(
      padding: paddings.all.s14,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: baseTextStyle.h6.copyWith(color: AppColors.textLight),
            textAlign: TextAlign.center,
          ),
          spacings.y.s4,
          const Spacer(),
          Row(
            children: [
              Text(
                value,
                style: baseTextStyle.h2,
                textAlign: TextAlign.center,
              ),
              spacings.x.s4,
              Text(
                unit,
                style: baseTextStyle.h6.copyWith(color: AppColors.textLight),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          if (subLabel != null) ...[
            spacings.y.s2,
            Text(
              subLabel!,
              style: baseTextStyle.body2.copyWith(
                color: subColor ?? Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
