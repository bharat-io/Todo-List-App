import 'package:flutter/material.dart';
import 'package:todo_list_app/model/todo.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Todo? todo; // null = Add, not null = Edit

  const AddEditTaskScreen({super.key, this.todo});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  String selectedPriority = 'Medium';
  bool reminder = false;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.todo?.title ?? '');

    descriptionController = TextEditingController(
      text: widget.todo?.description ?? '',
    );

    selectedPriority = widget.todo?.priority ?? 'Medium';
    reminder = widget.todo?.isCompleted ?? false;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
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
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
              decoration: InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Set Reminder'),
              value: reminder,
              onChanged: (value) {
                setState(() => reminder = value);
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // save or update logic later
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
