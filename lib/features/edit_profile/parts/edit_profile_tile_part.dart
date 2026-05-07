part of '../view/edit_profile_view.dart';

class EditProfileTilePart extends StatelessWidget {
  final String title;
  final String value;
  final Function() onTap;
  const EditProfileTilePart({
    super.key,
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: Text(value),
      onTap: onTap,
    );
  }
}
