import 'package:drifttutorial/features/todo/domain/models/todo.dart';

class TodoModel extends Todo {
  TodoModel({
    required super.id,
    required super.title,
    required super.description,
    required super.category,
    required super.priority,
    required super.isCompleted,
  });
  factory TodoModel.fromDb(dynamic row) {
    return TodoModel(
      id: row.id,
      title: row.title,
      description: row.description,
      category: _parseCategory(row.category as String),
      priority: _parsePriority(row.priority as String),
      isCompleted: row.isCompleted,
    );
  }

  static Category _parseCategory(String raw) {
    final normalized = raw.trim().toUpperCase();
    return Category.values.firstWhere((category) => category.label == normalized, orElse: () => Category.miscellaneous);
  }

  static Priority _parsePriority(String raw) {
    final normalized = raw.trim().toUpperCase();
    return Priority.values.firstWhere((priority) => priority.label == normalized, orElse: () => Priority.low);
  }
}
