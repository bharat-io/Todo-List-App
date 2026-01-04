import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list_app/model/todo.dart';
import 'package:todo_list_app/view/screens/add_edit_todo_screen.dart';

class TaskCard extends StatelessWidget {
  final Todo todo;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final ValueChanged<bool?>? onToggleComplete;
  const TaskCard({
    super.key,
    required this.todo,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleComplete,
  });

  Color getPriorityColor() {
    switch (todo.priority) {
      case 1:
        return Colors.red;
      case 3:
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  String get priorityLabel {
    switch (todo.priority) {
      case 1:
        return 'High';
      case 3:
        return 'Low';
      default:
        return 'Medium';
    }
  }

  String get formattedCreatedDate {
    return DateFormat('dd MMM, yyyy').format(todo.createdAt);
  }

  String get formattedDueTime {
    if (todo.dueDate == null) return '';
    return DateFormat('hh:mm a').format(todo.dueDate!);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(value: todo.isCompleted, onChanged: (_) {}),
                Expanded(
                  child: Text(
                    todo.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: todo.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddEditTodoScreen(todo: todo),
                      ),
                    );
                  },
                ),

                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(todo.description, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            Row(
              children: [
                Chip(
                  label: Text(priorityLabel),
                  backgroundColor: getPriorityColor().withOpacity(0.15),
                  labelStyle: TextStyle(color: getPriorityColor()),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 4),
                Text(formattedCreatedDate),
                const SizedBox(width: 12),
                if (todo.dueDate != null) ...[
                  const Icon(Icons.schedule, size: 16),
                  const SizedBox(width: 4),
                  Text(formattedDueTime),
                ],

                const Spacer(),
                if (todo.reminderTime != null)
                  const Icon(Icons.notifications_active, color: Colors.indigo),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
