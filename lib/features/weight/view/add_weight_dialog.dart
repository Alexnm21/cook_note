import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../config/router/router.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/styles/base_radius.dart';
import '../../../config/theme/styles/base_spaces.dart';
import '../../../config/theme/styles/base_text_style.dart';
import '../../../widgets/custom_button.dart';

class AddWeightDialog extends StatefulWidget {
  const AddWeightDialog({super.key, required this.onAdd});

  final void Function(double weightKg, DateTime date) onAdd;

  @override
  State<AddWeightDialog> createState() => _AddWeightDialogState();
}

class _AddWeightDialogState extends State<AddWeightDialog> {
  final TextEditingController _weightController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late DateTime _date = DateTime.now();

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: today,
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  String? _validateWeight(String? value) {
    final parsed = double.tryParse((value ?? '').trim().replaceAll(',', '.'));
    if (parsed == null || parsed <= 0 || parsed > 500) {
      return 'validation.invalid_number'.tr();
    }
    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final weight =
        double.parse(_weightController.text.trim().replaceAll(',', '.'));
    widget.onAdd(weight, _date);
    router.pop();
  }

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
              Text('weight.addTitle'.tr(), style: baseTextStyle.h2),
              spacings.y.s16,
              TextFormField(
                controller: _weightController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'weight.weightField'.tr(),
                  suffixText: 'kg',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(BaseRadius.s),
                  ),
                ),
                validator: _validateWeight,
              ),
              spacings.y.s16,
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(BaseRadius.s),
                child: Container(
                  width: double.infinity,
                  padding: paddings.all.s12,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.borderLight),
                    borderRadius: BorderRadius.circular(BaseRadius.s),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('weight.dateField'.tr(),
                          style:
                              baseTextStyle.h6.copyWith(color: Colors.grey)),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(DateFormat('dd/MM/yyyy').format(_date),
                              style: baseTextStyle.h6),
                          spacings.x.s8,
                          const Icon(Icons.calendar_today,
                              size: 16, color: AppColors.primary),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              spacings.y.s16,
              CustomButton(
                onPressed: _save,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check, color: Colors.white),
                    spacings.x.s8,
                    Text('profile.save'.tr(),
                        style:
                            baseTextStyle.h3.copyWith(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}