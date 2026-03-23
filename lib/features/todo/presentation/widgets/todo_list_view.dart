import 'package:drifttutorial/features/todo/domain/models/todo.dart';
import 'package:flutter/material.dart';

class TodoListView extends StatelessWidget {
  const TodoListView({
    required this.todos,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
    super.key,
  });

  final List<Todo> todos;
  final ValueChanged<Todo> onToggle;
  final ValueChanged<int> onDelete;
  final ValueChanged<Todo> onEdit;

  String _valueOrPlaceholder(String value, String placeholder) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? placeholder : trimmed;
  }

  @override
  Widget build(BuildContext context) {
    if (todos.isEmpty) {
      return const Center(child: Text('No todos yet. Tap + to add one.'));
    }

    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (_, i) {
        final todo = todos[i];
        final title = _valueOrPlaceholder(todo.title, 'Untitled todo');
        final description = _valueOrPlaceholder(todo.description, 'No description');
        final completionStatus = todo.isCompleted ? 'COMPLETED' : 'PENDING';
        return ListTile(
          title: Text(
            title,
            style: TextStyle(decoration: todo.isCompleted ? TextDecoration.lineThrough : TextDecoration.none),
          ),
          subtitle: Text('$description • ${todo.category.label} • ${todo.priority.label} • $completionStatus'),
          trailing: Checkbox(value: todo.isCompleted, onChanged: (_) => onToggle(todo)),
          onLongPress: () => onDelete(todo.id),
          onTap: () => onEdit(todo),
        );
      },
    );
  }
}
