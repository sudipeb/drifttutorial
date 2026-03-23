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
      category: row.category,
      priority: row.priority,
      isCompleted: row.isCompleted,
    );
  }
}
