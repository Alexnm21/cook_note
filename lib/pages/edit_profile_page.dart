import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../config/router/router.dart';
import '../config/theme/app_colors.dart';
import '../core/models/profile.dart';
import '../features/edit_profile/bloc/edit_profile_bloc.dart';
import '../features/edit_profile/view/edit_profile_view.dart';
import '../features/profile/bloc/profile_bloc.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({
    super.key,
    required this.profile,
  });

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditProfileBloc(
        initialProfile: profile,
      ),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('profile.edit'.tr()),
            actions: [
              IconButton(
                onPressed: () async {
                  await context.read<EditProfileBloc>().updateProfile();
                  router.pop();
                  context.read<ProfileBloc>().getProfile();
                },
                icon: const Icon(
                  Icons.save,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          body: const EditProfileView(),
        ),
      ),
    );
  }
}
