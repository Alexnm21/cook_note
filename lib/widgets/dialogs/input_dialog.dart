import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../config/router/router.dart';
import '../../config/theme/styles/base_radius.dart';
import '../../config/theme/styles/base_spaces.dart';
import '../../config/theme/styles/base_text_style.dart';
import '../custom_button.dart';

class InputDialog extends StatelessWidget {
  final String title;
  final Function(String) onSave;
  const InputDialog({super.key, required this.title, required this.onSave});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    return Dialog(
      child: Container(
        padding: paddings.all.s16,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(BaseRadius.s),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: baseTextStyle.h2),
            spacings.y.s10,
            TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(BaseRadius.s),
                ),
              ),
            ),
            spacings.y.s10,
            CustomButton(
              child: Text('profile.save'.tr()),
              onPressed: () {
                onSave(controller.text);
                router.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
