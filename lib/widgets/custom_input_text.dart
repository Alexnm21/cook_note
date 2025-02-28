import 'package:flutter/material.dart';

class CustomInputText extends StatelessWidget {
  final TextEditingController? controller;
  final String title;
  final Widget? icon;
  const CustomInputText(
      {super.key, this.controller, required this.title, this.icon});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
        prefixIcon: icon,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Campo requerido';
        }
        return null;
      },
    );
  }
}
