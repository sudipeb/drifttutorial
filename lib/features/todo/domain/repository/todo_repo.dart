import 'package:drifttutorial/features/todo/domain/models/todo.dart';

abstract class TodoRepository {
  Stream<List<Todo>> watchTodos();
  Future<void> addTodo(String title);
  Future<void> toggleTodo(Todo todo);
  Future<void> deleteTodo(int id);
}
