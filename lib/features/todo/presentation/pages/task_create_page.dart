import 'package:drifttutorial/features/todo/presentation/blocs/todo_cubit.dart';
import 'package:drifttutorial/features/todo/presentation/blocs/todo_state.dart';
import 'package:drifttutorial/features/todo/domain/models/todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplex/form/bloc_status.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  String _valueOrPlaceholder(String value, String placeholder) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? placeholder : trimmed;
  }

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
              return _buildTodoList(context, state.todos);
            },
            error: (msg) => Center(child: Text(msg ?? 'Something went wrong')),
            successWithData: (_, __) {
              return _buildTodoList(context, state.todos);
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

  Widget _buildTodoList(BuildContext context, List<Todo> todos) {
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
          trailing: Checkbox(
            value: todo.isCompleted,
            onChanged: (_) {
              context.read<TodoCubit>().toggleTodo(todo);
            },
          ),
          onLongPress: () {
            context.read<TodoCubit>().deleteTodo(todo.id);
          },
          onTap: () => _openEditTodoForm(context, todo),
        );
      },
    );
  }

  Future<void> _openCreateTodoForm(BuildContext context) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(fullscreenDialog: true, builder: (_) => const _CreateTodoPage()));
  }

  Future<void> _openEditTodoForm(BuildContext context, Todo todo) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(fullscreenDialog: true, builder: (_) => _CreateTodoPage(initialTodo: todo)));
  }
}

class _CreateTodoPage extends StatefulWidget {
  const _CreateTodoPage({this.initialTodo});

  final Todo? initialTodo;

  @override
  State<_CreateTodoPage> createState() => _CreateTodoPageState();
}

class _CreateTodoPageState extends State<_CreateTodoPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Category _selectedCategory = Category.miscellaneous;
  Priority _selectedPriority = Priority.low;
  bool _isSubmitting = false;

  bool get _isEditing => widget.initialTodo != null;

  @override
  void initState() {
    super.initState();
    final initialTodo = widget.initialTodo;
    if (initialTodo == null) return;

    _titleController.text = initialTodo.title;
    _descriptionController.text = initialTodo.description;
    _selectedCategory = initialTodo.category;
    _selectedPriority = initialTodo.priority;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext context) async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    if (_isEditing) {
      final initialTodo = widget.initialTodo!;
      await context.read<TodoCubit>().updateTodo(
        Todo(
          id: initialTodo.id,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          category: _selectedCategory,
          priority: _selectedPriority,
          isCompleted: initialTodo.isCompleted,
        ),
      );
    } else {
      await context.read<TodoCubit>().addTodo(
        _titleController.text.trim(),
        _descriptionController.text.trim(),
        _selectedPriority.label,
        _selectedCategory.label,
      );
    }

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Todo' : 'Create Todo')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter todo title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if ((value ?? '').trim().isEmpty) {
                  return 'Title is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter description (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<Category>(
              value: _selectedCategory,
              decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
              items: Category.values
                  .map((category) => DropdownMenuItem<Category>(value: category, child: Text(category.label)))
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<Priority>(
              initialValue: _selectedPriority,
              decoration: const InputDecoration(labelText: 'Priority', border: OutlineInputBorder()),
              items: Priority.values
                  .map((priority) => DropdownMenuItem<Priority>(value: priority, child: Text(priority.label)))
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _selectedPriority = value;
                });
              },
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _isSubmitting ? null : () => _submit(context),
              icon: _isSubmitting
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.check),
              label: Text(_isEditing ? 'UPDATE TODO' : 'SAVE TODO'),
            ),
          ],
        ),
      ),
    );
  }
}
