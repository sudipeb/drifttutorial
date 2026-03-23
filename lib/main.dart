import 'package:drifttutorial/core/database/app_database.dart';
import 'package:drifttutorial/features/todo/data/datasource/local_datasource.dart';
import 'package:drifttutorial/features/todo/data/repository/todo_repo_impl.dart';
import 'package:drifttutorial/features/todo/presentation/blocs/todo_cubit.dart';
import 'package:drifttutorial/features/todo/presentation/pages/task_create_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppDatabase _database;
  late final TodoRepositoryImpl _repository;

  @override
  void initState() {
    super.initState();
    _database = AppDatabase();
    _repository = TodoRepositoryImpl(TodoLocalDataSourceImpl(_database));
  }

  @override
  void dispose() {
    _database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TodoCubit(_repository),
      child: const MaterialApp(home: TodoPage()),
    );
  }
}
