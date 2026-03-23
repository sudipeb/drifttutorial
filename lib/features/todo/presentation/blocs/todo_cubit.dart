import 'dart:async';

import 'package:drifttutorial/features/todo/domain/models/todo.dart';
import 'package:drifttutorial/features/todo/domain/repository/todo_repo.dart';
import 'package:simplex/base/simplex_base_bloc.dart';
import 'package:simplex/form/bloc_status.dart';

import 'todo_state.dart';

class TodoCubit extends SimplexCubit<TodoState> {
  TodoCubit(this.todoRepository) : super(TodoState.initial());

  final TodoRepository todoRepository;
  StreamSubscription<List<Todo>>? _subscription;

  void loadTodos() {
    emit(state.copyWith(status: const BlocStatus.loading()));

    _subscription?.cancel();
    _subscription = todoRepository.watchTodos().listen(
      (todos) => emit(state.copyWith(todos: todos, status: const BlocStatus.success())),
      onError: (e) => emit(state.copyWith(status: BlocStatus.error(error: e.toString()))),
    );
  }

  Future<void> addTodo(String title, String description, String priority, String category) async {
    await todoRepository.addTodo(title, description, priority, category);
  }

  Future<void> updateTodo(Todo todo) async {
    await todoRepository.updateTodo(todo);
  }

  Future<void> toggleTodo(Todo todo) async {
    await todoRepository.toggleTodo(todo);
  }

  Future<void> deleteTodo(int id) async {
    await todoRepository.deleteTodo(id);
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
