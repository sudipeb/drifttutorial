import 'package:flutter/material.dart';

class TodoFormTextField extends StatelessWidget {
  const TodoFormTextField({
    required this.controller,
    required this.label,
    required this.hint,
    this.maxLines = 1,
    this.requiredField = false,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;
  final bool requiredField;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: label, hintText: hint, border: const OutlineInputBorder()),
      validator: requiredField
          ? (value) {
              if ((value ?? '').trim().isEmpty) {
                return '$label is required';
              }
              return null;
            }
          : null,
    );
  }
}
