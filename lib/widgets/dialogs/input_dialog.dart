import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../config/router/router.dart';
import '../../config/theme/styles/base_radius.dart';
import '../../config/theme/styles/base_spaces.dart';
import '../../config/theme/styles/base_text_style.dart';
import '../custom_button.dart';

class InputDialog extends StatefulWidget {
  final String title;
  final Function(String) onSave;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  const InputDialog({
    super.key,
    required this.title,
    required this.onSave,
    this.keyboardType,
    this.validator,
  });

  @override
  State<InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: paddings.all.s16,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(BaseRadius.s),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.title, style: baseTextStyle.h2),
              spacings.y.s10,
              TextFormField(
                controller: controller,
                keyboardType: widget.keyboardType,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(BaseRadius.s),
                  ),
                  errorText: errorText,
                ),
                validator: widget.validator,
                onChanged: (_) => setState(() => errorText = null),
              ),
              spacings.y.s10,
              CustomButton(
                child: Text('profile.save'.tr()),
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;
                  widget.onSave(controller.text);
                  router.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}