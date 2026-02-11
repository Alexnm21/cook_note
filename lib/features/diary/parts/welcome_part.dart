part of '../view/diary_view.dart';

class WelcomePart extends StatelessWidget {
  const WelcomePart({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'home.diary.greetings.morning'.tr();
    } else if (hour >= 12 && hour < 18) {
      return 'home.diary.greetings.evening'.tr();
    } else {
      return 'home.diary.greetings.night'.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state.loading) {
          return const SizedBox.shrink();
        }
        return Text(
          '¡${_getGreeting()}, ${state.profile.name}!',
          style: baseTextStyle.h1,
        );
      },
    );
  }
}
