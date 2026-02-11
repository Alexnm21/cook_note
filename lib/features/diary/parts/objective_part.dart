part of '../view/diary_view.dart';

class ObjectivePart extends StatefulWidget {
  const ObjectivePart({super.key});

  @override
  State<ObjectivePart> createState() => _ObjectivePartState();
}

class _ObjectivePartState extends State<ObjectivePart> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state.loading) {
          return const SizedBox.shrink();
        }

        DiaryDay diaryDay = state.diaryDay;

        return SingleChildScrollView(
          child: Column(
            children: [
              // * CALORIES
              Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedProgressionArc(
                    progress: diaryDay.getCalories().round() /
                        state.macroObjective(Macros.calories),
                    size: 200,
                    duration: const Duration(milliseconds: 800),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(diaryDay.getCalories().round().toString(),
                          style: const TextStyle(
                              fontSize: 48, fontWeight: FontWeight.bold)),
                      Text('de ${state.macroObjective(Macros.calories)} ',
                          style: const TextStyle(color: Colors.grey)),
                      Text('macros.calories'.tr()),
                    ],
                  ),
                ],
              ),
              ...Macros.values
                  .where((macro) => macro != Macros.calories)
                  .map((macro) => _MacrosBar(
                        label: macro.text,
                        value: diaryDay.getMacro(macro).round(),
                        objective: state.macroObjective(macro),
                        color: macro.color,
                      )),
            ],
          ),
        );
      },
    );
  }
}

class _MacrosBar extends StatelessWidget {
  final String label;
  final int value;
  final int objective;
  final Color color;
  const _MacrosBar({
    required this.label,
    required this.value,
    required this.objective,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: paddings.all.s10,
        margin: paddings.all.s10,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label, style: baseTextStyle.h3),
                Text('$value de $objective g', style: baseTextStyle.h3),
              ],
            ),
            spacings.y.s10,
            LayoutBuilder(
              builder: (context, constraints) {
                return AnimatedProgressionBar(
                  progress: value / objective,
                  width: constraints.maxWidth,
                  color: color,
                );
              },
            )
          ],
        ));
  }
}
