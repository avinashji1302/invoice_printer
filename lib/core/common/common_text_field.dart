  import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  TextEditingController controller;
  TextInputType textInputType;
  
   CustomTextField({super.key, required this.hint , required this.controller , this.textInputType=TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: textInputType,
      controller:controller ,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}