import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_app/contorller/bloc/todo_bloc.dart';
import 'package:todo_list_app/contorller/bloc/todo_event.dart';
import 'package:todo_list_app/model/todo.dart';

class AddEditTodoScreen extends StatefulWidget {
  final Todo? todo;

  const AddEditTodoScreen({super.key, this.todo});

  @override
  State<AddEditTodoScreen> createState() => _AddEditTodoScreenState();
}

class _AddEditTodoScreenState extends State<AddEditTodoScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  String selectedPriority = 'Medium';
  bool reminderEnabled = false;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.todo?.title ?? '');

    descriptionController = TextEditingController(
      text: widget.todo?.description ?? '',
    );

    if (widget.todo != null) {
      selectedPriority = _priorityToString(widget.todo!.priority);
      reminderEnabled = widget.todo!.reminderTime != null;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  int _priorityToInt(String value) {
    switch (value) {
      case 'High':
        return 1;
      case 'Low':
        return 3;
      default:
        return 2;
    }
  }

  String _priorityToString(int value) {
    switch (value) {
      case 1:
        return 'High';
      case 3:
        return 'Low';
      default:
        return 'Medium';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.todo != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Task' : 'Add Task')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedPriority,
              items: const [
                DropdownMenuItem(value: 'High', child: Text('High Priority')),
                DropdownMenuItem(
                  value: 'Medium',
                  child: Text('Medium Priority'),
                ),
                DropdownMenuItem(value: 'Low', child: Text('Low Priority')),
              ],
              onChanged: (value) {
                setState(() => selectedPriority = value!);
              },
              decoration: const InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Set Reminder'),
              value: reminderEnabled,
              onChanged: (value) {
                setState(() => reminderEnabled = value);
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final now = DateTime.now();

                  final todo = Todo(
                    id: isEdit ? widget.todo!.id : null,
                    title: titleController.text.trim(),
                    description: descriptionController.text.trim(),
                    priority: _priorityToInt(selectedPriority),
                    createdAt: isEdit ? widget.todo!.createdAt : DateTime.now(),
                    reminderTime: reminderEnabled
                        ? DateTime.now().add(const Duration(hours: 1))
                        : null,
                    isCompleted: widget.todo?.isCompleted ?? false,
                  );

                  context.read<TodoBloc>().add(AddTodoEvent(todo: todo));

                  Navigator.pop(context);
                },
                child: Text(isEdit ? 'Update Task' : 'Add Task'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
