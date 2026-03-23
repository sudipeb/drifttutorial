import 'package:drifttutorial/features/todo/domain/models/todo.dart';

abstract class TodoRepository {
  Stream<List<Todo>> watchTodos();
  Future<void> addTodo(String title, String description, String priority, String category);
  Future<void> updateTodo(Todo todo);
  Future<void> toggleTodo(Todo todo);
  Future<void> deleteTodo(int id);
}
