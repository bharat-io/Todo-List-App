import 'package:flutter/material.dart';
import 'package:todo_list_app/model/todo.dart';
import 'package:todo_list_app/view/widgets/task_card.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'priority', child: Text('Sort by Priority')),
              PopupMenuItem(value: 'due', child: Text('Sort by Due Date')),
              PopupMenuItem(
                value: 'created',
                child: Text('Sort by Created Date'),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search tasks...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: demoTasks.length,
              itemBuilder: (context, index) {
                return TaskCard(todo: demoTasks[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

final List<Todo> demoTasks = [
  Todo(
    title: 'Finish Flutter UI',
    description: 'Design Todo app UI for assignment',
    priority: 'High',
    dueDate: '05 Jan 2026',
    isCompleted: false,
  ),
  Todo(
    title: 'Buy groceries',
    description: 'Milk, vegetables, fruits',
    priority: 'Medium',
    dueDate: '06 Jan 2026',
    isCompleted: true,
  ),
  Todo(
    title: 'Workout',
    description: 'Evening gym session',
    priority: 'Low',
    dueDate: '07 Jan 2026',
    isCompleted: false,
  ),
];
