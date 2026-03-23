import 'package:drifttutorial/features/todo/domain/models/todo.dart';
import 'package:drifttutorial/features/todo/presentation/blocs/todo_cubit.dart';
import 'package:drifttutorial/features/todo/presentation/widgets/todo_enum_dropdown.dart';
import 'package:drifttutorial/features/todo/presentation/widgets/todo_form_submit_button.dart';
import 'package:drifttutorial/features/todo/presentation/widgets/todo_form_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoFormWidget extends StatefulWidget {
  const TodoFormWidget({this.initialTodo, this.onSaved, super.key});

  final Todo? initialTodo;
  final VoidCallback? onSaved;

  bool get isEditing => initialTodo != null;

  @override
  State<TodoFormWidget> createState() => _TodoFormWidgetState();
}

class _TodoFormWidgetState extends State<TodoFormWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Category _selectedCategory = Category.miscellaneous;
  Priority _selectedPriority = Priority.low;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _hydrateFromInitial();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _hydrateFromInitial() {
    final initialTodo = widget.initialTodo;
    if (initialTodo == null) return;

    _titleController.text = initialTodo.title;
    _descriptionController.text = initialTodo.description;
    _selectedCategory = initialTodo.category;
    _selectedPriority = initialTodo.priority;
  }

  Future<void> _submit(BuildContext context) async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (widget.isEditing) {
      final initialTodo = widget.initialTodo!;
      await context.read<TodoCubit>().updateTodo(
        Todo(
          id: initialTodo.id,
          title: title,
          description: description,
          category: _selectedCategory,
          priority: _selectedPriority,
          isCompleted: initialTodo.isCompleted,
        ),
      );
    } else {
      await context.read<TodoCubit>().addTodo(title, description, _selectedPriority.label, _selectedCategory.label);
    }

    if (!mounted) return;
    widget.onSaved?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TodoFormTextField(
            controller: _titleController,
            label: 'Title',
            hint: 'Enter todo title',
            requiredField: true,
          ),
          const SizedBox(height: 12),
          TodoFormTextField(
            controller: _descriptionController,
            label: 'Description',
            hint: 'Enter description (optional)',
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          TodoEnumDropdown<Category>(
            value: _selectedCategory,
            label: 'Category',
            options: Category.values,
            labelBuilder: (category) => category.label,
            onChanged: (value) {
              setState(() {
                _selectedCategory = value;
              });
            },
          ),
          const SizedBox(height: 12),
          TodoEnumDropdown<Priority>(
            value: _selectedPriority,
            label: 'Priority',
            options: Priority.values,
            labelBuilder: (priority) => priority.label,
            onChanged: (value) {
              setState(() {
                _selectedPriority = value;
              });
            },
          ),
          const SizedBox(height: 20),
          TodoFormSubmitButton(
            isSubmitting: _isSubmitting,
            isEditing: widget.isEditing,
            onPressed: () => _submit(context),
          ),
        ],
      ),
    );
  }
}
