import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/svg_icon.dart';

showAlertDialog(
  BuildContext context, {
  String title = '',
  String body = '',
  Function()? onAccept,
  Function()? onReject,
}) {
  showDialog(
    context: context,
    builder: (context) => CustomDialog(
      icon: const SvgIcon(
        icon: 'alert',
        size: 100,
        color: AppColors.error,
      ),
      title: title,
      body: body,
      onAccept: onAccept,
      onReject: onReject,
    ),
  );
}
