import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../config/router/router.dart';
import '../config/theme/app_colors.dart';
import '../config/theme/styles/base_spaces.dart';
import '../config/theme/styles/base_text_style.dart';
import 'custom_button.dart';

class CustomDialog extends StatelessWidget {
  final Widget? icon;
  final String title;
  final String body;
  final Function()? onAccept;
  final Function()? onReject;
  const CustomDialog({
    super.key,
    this.title = '',
    this.body = '',
    this.icon,
    this.onAccept,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: paddings.all.s16,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            spacings.y.s10,
            if (icon != null) icon!,
            spacings.y.s10,
            Text(title, style: baseTextStyle.h1),
            spacings.y.s20,
            Text(body, style: baseTextStyle.h3),
            spacings.y.s20,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  onPressed: () {
                    onAccept?.call();
                    router.pop();
                  },
                  child: Text('core.accept'.tr(),
                      style: baseTextStyle.h2.copyWith(color: Colors.white)),
                ),
                if (onReject != null)
                  CustomButton(
                    onPressed: () {
                      onReject?.call();
                      router.pop();
                    },
                    color: AppColors.error,
                    child: Text('core.reject'.tr(), style: baseTextStyle.h2),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
