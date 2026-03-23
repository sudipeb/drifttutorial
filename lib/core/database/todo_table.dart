import 'package:drift/drift.dart';


class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get category => text()();
  TextColumn get priority => text()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
}
