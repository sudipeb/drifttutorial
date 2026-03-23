import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drifttutorial/core/database/todo_table.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
part 'app_database.g.dart';

@DriftDatabase(tables: [Todos])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  ///Schema Version(Increment when Db changes)
  @override
  int get schemaVersion => 1;

  /// optional:handle Migrations in future
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    // Handle migrations here when schema changes
    onUpgrade: (m, from, to) async {},
  );
}

/// Database connection setup
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // Get application documents directory
    final dbFolder = await getApplicationDocumentsDirectory();

    // Create db file path
    final file = File(p.join(dbFolder.path, 'todo_db.sqlite'));

    // Return native sqlite database
    return NativeDatabase(file);
  });
}
