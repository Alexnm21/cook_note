import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/router/router.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/styles/base_spaces.dart';
import '../../../config/theme/styles/base_text_style.dart';
import '../../../core/blocs/user_bloc.dart';
import '../../../core/enums/activity_level.dart';
import '../../../core/enums/gender.dart';
import '../../../core/enums/goal.dart';
import '../../../widgets/custom_button.dart';
import '../bloc/profile_bloc.dart';

part '../parts/info_card_part.dart';
part '../parts/info_row_part.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      if (state.loading) {
        return const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        );
      }

      final profile = state.profile;
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildProfileHeader(
              profile.name,
              () {
                router.pushNamed(Routes.editProfile.name, extra: profile);
              },
            ),
            spacings.y.s24,
            InfoCardPart(
              title: 'profile.personal_info'.tr(),
              children: [
                InfoRowPart(label: 'core.name'.tr(), value: profile.name),
                InfoRowPart(
                    label: 'profile.age'.tr(), value: '${profile.age} años'),
                InfoRowPart(
                    label: 'profile.gender.title'.tr(),
                    value: profile.gender.text),
              ],
            ),
            spacings.y.s24,
            InfoCardPart(
              title: 'profile.physical_info'.tr(),
              children: [
                InfoRowPart(
                    label: 'profile.height'.tr(),
                    value: '${profile.height} cm'),
                InfoRowPart(
                    label: 'profile.weight'.tr(),
                    value: '${profile.weight} kg'),
                InfoRowPart(
                  label: 'profile.activity_level.title'.tr(),
                  value: profile.activityLevel.text,
                ),
                InkWell(
                  onTap: () {
                    router.pushNamed(
                      Routes.weightEvolution.name,
                      extra: profile,
                    );
                  },
                  child: Padding(
                    padding: paddings.bottom.s12,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('weight.title'.tr(),
                            style: baseTextStyle.h3
                                .copyWith(color: Colors.grey[600])),
                        const Icon(
                          Icons.chevron_right,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            spacings.y.s24,
            InfoCardPart(
              title: 'profile.goals'.tr(),
              children: [
                InfoRowPart(
                  label: 'profile.goal.title'.tr(),
                  value: profile.goal.text,
                ),
                InfoRowPart(
                  label: 'profile.target_weight'.tr(),
                  value: profile.targetWeight != null
                      ? '${profile.targetWeight} kg'
                      : '${profile.weight} kg',
                ),
              ],
            ),
            spacings.y.s24,
            Container(
              margin: paddings.x.s16,
              width: double.infinity,
              child: CustomButton(
                onPressed: () {
                  context.read<UserBloc>().logout();
                },
                color: AppColors.primary,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout, color: Colors.white),
                    spacings.x.s8,
                    Text('core.logout'.tr(),
                        style: baseTextStyle.h2.copyWith(color: Colors.white)),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  Widget _buildProfileHeader(String name, Function() onEdit) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 40), // Espacio para balancear
              CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.primary,
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : 'U',
                  style: baseTextStyle.h1.copyWith(
                    color: Colors.white,
                    fontSize: 32,
                  ),
                ),
              ),
              IconButton(
                onPressed: onEdit,
                icon: const Icon(
                  Icons.edit,
                  color: AppColors.primary,
                  size: 24,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(8),
                ),
              ),
            ],
          ),
          spacings.y.s12,
          Text(
            name,
            style: baseTextStyle.h1,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
