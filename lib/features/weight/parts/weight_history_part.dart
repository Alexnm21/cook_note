part of '../view/weight_view.dart';

class WeightHistoryPart extends StatelessWidget {
  const WeightHistoryPart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeightBloc, WeightState>(
      builder: (context, state) {
        final items = state.records.reversed.toList();
        return Column(
          children: [
            for (var i = 0; i < items.length; i++) _buildTile(context, items, i),
          ],
        );
      },
    );
  }

  Widget _buildTile(BuildContext context, List<WeightRecord> items, int index) {
    final record = items[index];
    final change = index + 1 < items.length
        ? record.weightKg - items[index + 1].weightKg
        : null;

    return Container(
      margin: paddings.bottom.s8,
      padding: paddings.all.s12,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(BaseRadius.s),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.monitor_weight, color: Colors.white, size: 20),
          ),
          spacings.x.s12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('d MMMM yyyy').format(record.date),
                  style: baseTextStyle.h6,
                ),
                if (change != null && change.abs() > 0)
                  Text(
                    '${change > 0 ? '+' : ''}${change.toStringAsFixed(1)} kg',
                    style: baseTextStyle.body.copyWith(
                      color: change < 0 ? Colors.green : AppColors.error,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            '${record.weightKg.toStringAsFixed(1)} ${'weight.kg'.tr()}',
            style: baseTextStyle.h3,
          ),
        ],
      ),
    );
  }
}