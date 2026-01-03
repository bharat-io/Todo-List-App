import 'package:flutter/material.dart';
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
                onPressed: () {},
                child: Text(isEdit ? 'Update Task' : 'Add Task'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
