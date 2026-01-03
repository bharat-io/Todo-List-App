class Todo {
  final String title;
  final String description;
  final String priority;
  final String dueDate;
  final bool isCompleted;

  Todo({
    required this.title,
    required this.description,
    required this.priority,
    required this.dueDate,
    this.isCompleted = false,
  });
}
