import 'package:drifttutorial/features/todo/data/datasource/local_datasource.dart';
import 'package:drifttutorial/features/todo/domain/repository/todo_repo.dart';

import '../../domain/models/todo.dart';

import '../models/todo_model.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource local;

  TodoRepositoryImpl(this.local);

  @override
  Stream<List<Todo>> watchTodos() {
    return local.watchTodos();
  }

  @override
  Future<void> addTodo(String title, String description, String priority, String category) {
    return local.insert(title, description, priority, category);
  }

  @override
  Future<void> toggleTodo(Todo todo) {
    final updated = TodoModel(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      priority: todo.priority,
      category: todo.category,
      isCompleted: !todo.isCompleted,
    );
    return local.update(updated);
  }

  @override
  Future<void> deleteTodo(int id) {
    return local.delete(id);
  }
}
