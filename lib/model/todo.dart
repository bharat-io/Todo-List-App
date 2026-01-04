class Todo {
  final int? id;
  final String title;
  final String description;
  final int priority;
  final DateTime createdAt;
  final DateTime? dueDate; // 🔹 Full Date + Time
  final DateTime? reminderTime;
  final bool isCompleted;

  Todo({
    this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.createdAt,
    this.dueDate,
    this.reminderTime,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'priority': priority,
      'created_at': createdAt.millisecondsSinceEpoch,
      'due_date': dueDate?.millisecondsSinceEpoch,
      'reminder_time': reminderTime?.millisecondsSinceEpoch,
      'is_completed': isCompleted ? 1 : 0,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      priority: map['priority'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      dueDate: map['due_date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['due_date'])
          : null,
      reminderTime: map['reminder_time'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['reminder_time'])
          : null,
      isCompleted: map['is_completed'] == 1,
    );
  }
}
