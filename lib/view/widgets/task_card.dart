import 'package:flutter/material.dart';
import 'package:todo_list_app/model/todo.dart';

class TaskCard extends StatelessWidget {
  final Todo todo;
  const TaskCard({super.key, required this.todo});

  Color getPriorityColor() {
    switch (todo.priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      default:
        return Colors.green;
    }
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
                IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
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
                  label: Text(todo.priority),
                  backgroundColor: getPriorityColor().withOpacity(0.15),
                  labelStyle: TextStyle(color: getPriorityColor()),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 4),
                Text(todo.dueDate),
                const Spacer(),
                const Icon(Icons.notifications_active, color: Colors.indigo),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
