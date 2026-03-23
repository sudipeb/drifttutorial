import 'package:drifttutorial/features/todo/domain/models/todo.dart';
import 'package:simplex/form/bloc_status.dart';

class TodoState {
  final List<Todo> todos;
  final BlocStatus status;

  const TodoState({this.todos = const [], this.status = const BlocStatus.initial()});

  factory TodoState.initial() => const TodoState();

  factory TodoState.loading() => const TodoState(status: BlocStatus.loading());

  factory TodoState.loaded(List<Todo> todos) => TodoState(todos: todos, status: const BlocStatus.success());

  factory TodoState.error(String message) => TodoState(status: BlocStatus.error(error: message));

  bool get isLoading => status.isLoading;

  String? get errorMessage => status.when(
    initial: () => null,
    invalid: (_) => null,
    loading: () => null,
    success: (_) => null,
    error: (error) => error,
    successWithData: (_, _) => null,
  );

  TodoState copyWith({List<Todo>? todos, BlocStatus? status}) {
    return TodoState(todos: todos ?? this.todos, status: status ?? this.status);
  }
}
