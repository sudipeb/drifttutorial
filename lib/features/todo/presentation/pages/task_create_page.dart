import 'package:drifttutorial/features/todo/domain/models/todo.dart';
import 'package:drifttutorial/features/todo/presentation/blocs/todo_cubit.dart';
import 'package:drifttutorial/features/todo/presentation/blocs/todo_state.dart';
import 'package:drifttutorial/features/todo/presentation/widgets/todo_form_widget.dart';
import 'package:drifttutorial/features/todo/presentation/widgets/todo_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplex/form/bloc_status.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todos')),
      body: BlocBuilder<TodoCubit, TodoState>(
        builder: (context, state) {
          return state.status.when(
            initial: () {
              context.read<TodoCubit>().loadTodos();
              return const Center(child: CircularProgressIndicator());
            },
            invalid: (_) => const SizedBox.shrink(),
            loading: () => const Center(child: CircularProgressIndicator()),
            success: (_) {
              return TodoListView(
                todos: state.todos,
                onToggle: (todo) => context.read<TodoCubit>().toggleTodo(todo),
                onDelete: (id) => context.read<TodoCubit>().deleteTodo(id),
                onEdit: (todo) => _openEditTodoForm(context, todo),
              );
            },
            error: (msg) => Center(child: Text(msg ?? 'Something went wrong')),
            successWithData: (_, _) {
              return TodoListView(
                todos: state.todos,
                onToggle: (todo) => context.read<TodoCubit>().toggleTodo(todo),
                onDelete: (id) => context.read<TodoCubit>().deleteTodo(id),
                onEdit: (todo) => _openEditTodoForm(context, todo),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openCreateTodoForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _openCreateTodoForm(BuildContext context) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(fullscreenDialog: true, builder: (_) => const _TodoFormScreen()));
  }

  Future<void> _openEditTodoForm(BuildContext context, Todo todo) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(fullscreenDialog: true, builder: (_) => _TodoFormScreen(initialTodo: todo)));
  }
}

class _TodoFormScreen extends StatelessWidget {
  const _TodoFormScreen({this.initialTodo});

  final Todo? initialTodo;

  bool get _isEditing => initialTodo != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Todo' : 'Create Todo')),
      body: TodoFormWidget(initialTodo: initialTodo, onSaved: () => Navigator.of(context).pop()),
    );
  }
}
