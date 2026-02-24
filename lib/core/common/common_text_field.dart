import 'package:app/core/constants/validators.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  TextEditingController controller;
  TextInputType textInputType;
  String? validator;

  CustomTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.textInputType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      controller: controller,
      validator: (value) {
        if (value!.isEmpty) {
          return Validators.validateName(hint , value);
        }

        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
