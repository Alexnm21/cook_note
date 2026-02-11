part of '../view/diary_view.dart';

class DateSelectorPart extends StatelessWidget {
  const DateSelectorPart({super.key});

  @override
  Widget build(BuildContext context) {
    List<DateTime> days = List.generate(
        7, (index) => DateTime.now().add(Duration(days: index - 3)));
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: paddings.x.s8,
              child: Text(
                  '${state.selectedDate.weekdayName} ${state.selectedDate.day}, ${state.selectedDate.year}',
                  style: baseTextStyle.h3),
            ),
            spacings.y.s10,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...days.map((day) => _DayButton(
                      date: day,
                      isSelected: _isSameDay(day, state.selectedDate),
                      onDateSelected: (date) =>
                          context.read<ProfileBloc>().setSelectedDate(date),
                    )),
              ],
            ),
          ],
        );
      },
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

class _DayButton extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final Function(DateTime) onDateSelected;
  const _DayButton(
      {required this.date,
      required this.isSelected,
      required this.onDateSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onDateSelected(date),
      child: Container(
          padding: paddings.x.s8,
          color: Colors.transparent,
          child: Column(
            children: [
              Text(date.weekdayShortName, style: baseTextStyle.h3),
              spacings.y.s4,
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: paddings.all.s4,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.black.withOpacity(0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(BaseRadius.circle),
                ),
                child: Text(date.day.toString(), style: baseTextStyle.h3),
              ),
            ],
          )),
    );
  }
}
