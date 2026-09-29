part of '../view/weight_view.dart';

class WeightChartPart extends StatelessWidget {
  const WeightChartPart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<WeightBloc, WeightState>(
          builder: (context, state) {
            return CustomSelectionWidget(
              borderRadius: BaseRadius.circle,
              options: WeightRange.values
                  .map((range) => _rangeLabel(range))
                  .toList(),
              selectedOption: _rangeLabel(state.range),
              onSelected: (option) {
                final range = WeightRange.values.firstWhere(
                  (r) => _rangeLabel(r) == option,
                );
                context.read<WeightBloc>().setRange(range);
              },
            );
          },
        ),
        spacings.y.s12,
        _buildChartCard(),
      ],
    );
  }

  Widget _buildChartCard() {
    return BlocBuilder<WeightBloc, WeightState>(
      builder: (context, state) {
        final records = state.recordsInRange;
        return CookNoteContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('weight.curve'.tr(), style: baseTextStyle.h2),
              if (records.isNotEmpty) ...[
                spacings.y.s4,
                Text(
                  '${DateFormat('dd/MM/yyyy').format(records.first.date)} — ${DateFormat('dd/MM/yyyy').format(records.last.date)}',
                  style: baseTextStyle.body3.copyWith(color: Colors.grey),
                ),
              ],
              spacings.y.s16,
              if (records.length >= 2)
                LayoutBuilder(
                  builder: (context, constraints) {
                    return CustomPaint(
                      size: Size(constraints.maxWidth, 180),
                      painter: _WeightChartPainter(
                        records: records,
                        lineColor: AppColors.primary,
                        dotColor: AppColors.primary,
                        labelColor: Colors.grey,
                      ),
                    );
                  },
                )
              else
                Padding(
                  padding: paddings.y.s24,
                  child: Center(
                    child: Text(
                      records.isEmpty
                          ? 'weight.emptyChart'.tr()
                          : 'weight.needTwo'.tr(),
                      style: baseTextStyle.body3.copyWith(color: Colors.grey),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

String _rangeLabel(WeightRange range) {
  return switch (range) {
    WeightRange.oneMonth => '1M',
    WeightRange.threeMonths => '3M',
    WeightRange.sixMonths => '6M',
    WeightRange.oneYear => '1A',
    WeightRange.all => 'weight.rangeAll'.tr(),
  };
}

class _WeightChartPainter extends CustomPainter {
  final List<WeightRecord> records;
  final Color lineColor;
  final Color dotColor;
  final Color labelColor;

  _WeightChartPainter({
    required this.records,
    required this.lineColor,
    required this.dotColor,
    required this.labelColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final n = records.length;
    final minW = records.map((r) => r.weightKg).reduce(min);
    final maxW = records.map((r) => r.weightKg).reduce(max);
    final rangeW = maxW - minW;
    const leftPad = 40.0;
    const rightPad = 16.0;
    const topPad = 20.0;
    const bottomPad = 16.0;
    final usableW = size.width - leftPad - rightPad;
    final usableH = size.height - topPad - bottomPad;

    double xFor(int i) => leftPad + (i / (n - 1)) * usableW;

    double yFor(double w) =>
        topPad + (1 - (rangeW == 0 ? 0 : (w - minW) / rangeW)) * usableH;

    final gridPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.3)
      ..strokeWidth = 1;

    final minY = yFor(minW);
    final maxY = yFor(maxW);
    canvas.drawLine(Offset(leftPad, maxY), Offset(size.width, maxY), gridPaint);
    canvas.drawLine(Offset(leftPad, minY), Offset(size.width, minY), gridPaint);

    _drawValueLabel(canvas, minW.toStringAsFixed(1), Offset(0, minY - 7));
    _drawValueLabel(canvas, maxW.toStringAsFixed(1), Offset(0, maxY - 7));

    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()..moveTo(xFor(0), yFor(records[0].weightKg));
    for (var i = 1; i < n; i++) {
      path.lineTo(xFor(i), yFor(records[i].weightKg));
    }
    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()..color = dotColor;
    for (var i = 0; i < n; i++) {
      canvas.drawCircle(
          Offset(xFor(i), yFor(records[i].weightKg)), 3.5, dotPaint);
    }
  }

  void _drawValueLabel(Canvas canvas, String text, Offset offset) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(fontSize: 10, color: labelColor),
      ),
      textDirection: ui.TextDirection.ltr,
    )..layout();
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(_WeightChartPainter oldDelegate) =>
      oldDelegate.records != records;
}
