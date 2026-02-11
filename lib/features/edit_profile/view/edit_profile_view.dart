import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/styles/base_radius.dart';
import '../../../config/theme/styles/base_spaces.dart';
import '../../../core/enums/activity_level.dart';
import '../../../core/enums/gender.dart';
import '../../../core/enums/goal.dart';
import '../../../widgets/dialogs/input_dialog.dart';
import '../../../widgets/dialogs/single_selection_profile_dialog.dart';
import '../bloc/edit_profile_bloc.dart';

part '../parts/edit_profile_tile_part.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: paddings.all.s16,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(BaseRadius.m),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: BlocBuilder<EditProfileBloc, EditProfileState>(
        builder: (context, state) {
          return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 6,
              separatorBuilder: (context, index) => const _Divider(),
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return EditProfileTilePart(
                      title: 'profile.name'.tr(),
                      value: state.profile.name ?? '',
                      onTap: () {
                        showInputDialog(context, 'profile.name'.tr(), (value) {
                          context.read<EditProfileBloc>().onChangeProfile(
                                state.profile.copyWith(name: value),
                              );
                        });
                      },
                    );
                  case 1:
                    return EditProfileTilePart(
                      title: 'profile.weight'.tr(),
                      value: '${state.profile.weight} kg',
                      onTap: () {
                        showInputDialog(context, 'profile.weight'.tr(),
                            (value) {
                          context.read<EditProfileBloc>().onChangeProfile(
                                state.profile
                                    .copyWith(weight: int.parse(value)),
                              );
                        });
                      },
                    );
                  case 2:
                    return EditProfileTilePart(
                      title: 'profile.gender.title'.tr(),
                      value:
                          'profile.gender.${state.profile.gender?.name}'.tr(),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => SingleSelectionProfileDialog<Gender>(
                            title: 'profile.gender.title'.tr(),
                            list: Gender.values,
                            onSelected: (selected) {
                              context.read<EditProfileBloc>().onChangeProfile(
                                    state.profile.copyWith(gender: selected),
                                  );
                            },
                          ),
                        );
                      },
                    );
                  case 3:
                    return EditProfileTilePart(
                      title: 'profile.age'.tr(),
                      value: '${state.profile.age}',
                      onTap: () {
                        showInputDialog(context, 'profile.age'.tr(), (value) {
                          context.read<EditProfileBloc>().onChangeProfile(
                                state.profile.copyWith(age: int.parse(value)),
                              );
                        });
                      },
                    );
                  case 4:
                    return EditProfileTilePart(
                      title: 'profile.activity_level.title'.tr(),
                      value:
                          'profile.activity_level.${state.profile.activityLevel?.name}'
                              .tr(),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) =>
                              SingleSelectionProfileDialog<ActivityLevel>(
                            title: 'profile.activity_level.title'.tr(),
                            list: ActivityLevel.values,
                            onSelected: (selected) {
                              context.read<EditProfileBloc>().onChangeProfile(
                                    state.profile
                                        .copyWith(activityLevel: selected),
                                  );
                            },
                          ),
                        );
                      },
                    );
                  case 5:
                    return EditProfileTilePart(
                      title: 'profile.goal.title'.tr(),
                      value: 'profile.goal.${state.profile.goal?.name}'.tr(),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => SingleSelectionProfileDialog<Goal>(
                            title: 'profile.goal.title'.tr(),
                            list: Goal.values,
                            onSelected: (selected) {
                              context.read<EditProfileBloc>().onChangeProfile(
                                    state.profile.copyWith(goal: selected),
                                  );
                            },
                          ),
                        );
                      },
                    );
                  default:
                    return const SizedBox.shrink();
                }
              });
        },
      ),
    );
  }

  showInputDialog(BuildContext context, String title, Function(String) onSave) {
    return showDialog(
      context: context,
      builder: (_) => InputDialog(title: title, onSave: onSave),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1);
  }
}
