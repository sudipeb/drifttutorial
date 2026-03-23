import 'package:flutter/material.dart';

class TodoFormSubmitButton extends StatelessWidget {
  const TodoFormSubmitButton({required this.isSubmitting, required this.isEditing, required this.onPressed, super.key});

  final bool isSubmitting;
  final bool isEditing;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: isSubmitting ? null : onPressed,
      icon: isSubmitting
          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
          : const Icon(Icons.check),
      label: Text(isEditing ? 'UPDATE TODO' : 'SAVE TODO'),
    );
  }
}
