import 'package:drifttutorial/core/interfaces/labelled_enum.dart';

class Todo {
  final int id;
  final String title;
  final String description;
  final Category category;
  bool isCompleted;
  final Priority priority;
  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.isCompleted = false,
    required this.priority,
  });
}

enum Category implements LabeledEnum {
  miscellaneous("MISCELLANEOUS"),
  household("HOUSEHOLD"),
  office("OFFICE"),
  project("PROJECT"),
  client("CLIENT");

  @override
  final String label;
  const Category(this.label);
}

enum Priority implements LabeledEnum {
  low("LOW"),
  medium("MEDIUM"),
  high("HIGH"),
  urgent("URGENT");

  @override
  final String label;
  const Priority(this.label);
}
