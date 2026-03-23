import 'package:flutter/material.dart';

class TodoEnumDropdown<T> extends StatelessWidget {
  const TodoEnumDropdown({
    required this.value,
    required this.label,
    required this.options,
    required this.labelBuilder,
    required this.onChanged,
    super.key,
  });

  final T value;
  final String label;
  final List<T> options;
  final String Function(T option) labelBuilder;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      items: options.map((option) => DropdownMenuItem<T>(value: option, child: Text(labelBuilder(option)))).toList(),
      onChanged: (next) {
        if (next == null) return;
        onChanged(next);
      },
    );
  }
}
