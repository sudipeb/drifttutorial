import 'package:drift/drift.dart';
import 'package:drifttutorial/core/database/app_database.dart';
import 'package:drifttutorial/features/todo/data/models/todo_model.dart';
import 'package:flutter/foundation.dart';

abstract class TodoLocalDataSource {
  Stream<List<TodoModel>> watchTodos();
  Future<void> insert(String title, String description, String category, String priority);
  Future<void> update(TodoModel todo);
  Future<void> delete(int id);
}

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  final AppDatabase db;

  TodoLocalDataSourceImpl(this.db);

  @override
  Stream<List<TodoModel>> watchTodos() {
    return db.select(db.todos).watch().map((rows) => rows.map((e) => TodoModel.fromDb(e)).toList());
  }

  @override
  Future<void> insert(String title, String description, String category, String priority) async {
    await db
        .into(db.todos)
        .insert(TodosCompanion.insert(title: title, description: description, category: category, priority: priority));
  }

  @override
  Future<void> update(TodoModel todo) async {
    await db
        .update(db.todos)
        .replace(TodosCompanion(id: Value(todo.id), title: Value(todo.title), isCompleted: Value(todo.isCompleted)));
  }

  @override
  Future<void> delete(int id) async {
    await (db.delete(db.todos)..where((t) => t.id.equals(id))).go();
  }
}
