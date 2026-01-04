import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_list_app/contorller/bloc/todo_bloc.dart';
import 'package:todo_list_app/contorller/bloc/todo_event.dart';
import 'package:todo_list_app/model/todo.dart';
import 'package:todo_list_app/contorller/notification/notification_service.dart';

class AddEditTodoScreen extends StatefulWidget {
  final Todo? todo;

  const AddEditTodoScreen({super.key, this.todo});

  @override
  State<AddEditTodoScreen> createState() => _AddEditTodoScreenState();
}

class _AddEditTodoScreenState extends State<AddEditTodoScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  DateTime? selectedDueDateTime;
  int reminderMinutes = 30; // default reminder 30 min
  String selectedPriority = 'Medium';
  bool reminderEnabled = false;

  final List<Map<String, int>> reminderOptions = [
    {'5 min before': 5},
    {'30 min before': 30},
    {'1 hour before': 60},
    {'1 day before': 1440},
  ];

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.todo?.title ?? '');
    descriptionController = TextEditingController(
      text: widget.todo?.description ?? '',
    );

    if (widget.todo?.dueDate != null) {
      selectedDueDateTime = widget.todo!.dueDate;
    }

    reminderEnabled = widget.todo?.reminderTime != null;

    if (widget.todo?.reminderTime != null && selectedDueDateTime != null) {
      reminderMinutes = selectedDueDateTime!
          .difference(widget.todo!.reminderTime!)
          .inMinutes;
    }
  }

  Future<void> pickDueDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDueDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedDueDateTime != null
          ? TimeOfDay.fromDateTime(selectedDueDateTime!)
          : TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    setState(() {
      selectedDueDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
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
            // Title
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Description
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Priority Dropdown
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
            // Due Date & Time Picker
            ListTile(
              title: Text(
                selectedDueDateTime == null
                    ? 'Select Due Time'
                    : 'Due at: ${DateFormat('dd MMM yyyy, hh:mm a').format(selectedDueDateTime!)}',
              ),
              trailing: const Icon(Icons.access_time),
              onTap: pickDueDateTime,
            ),
            // Reminder Switch
            if (selectedDueDateTime != null)
              SwitchListTile(
                title: const Text('Set Reminder'),
                value: reminderEnabled,
                onChanged: (value) {
                  setState(() => reminderEnabled = value);
                },
              ),
            const SizedBox(height: 16),
            // Reminder Minutes Dropdown
            if (reminderEnabled && selectedDueDateTime != null)
              DropdownButtonFormField<int>(
                value: reminderMinutes,
                items: reminderOptions
                    .map(
                      (e) => DropdownMenuItem(
                        value: e.values.first,
                        child: Text(e.keys.first),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() => reminderMinutes = value!);
                },
                decoration: const InputDecoration(
                  labelText: 'Reminder Time',
                  border: OutlineInputBorder(),
                ),
              ),
            const SizedBox(height: 24),
            // Add/Update Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (titleController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Title is required')),
                    );
                    return;
                  }

                  DateTime? dueTime;
                  DateTime? reminderTime;
                  final now = DateTime.now();

                  if (selectedDueDateTime != null) {
                    dueTime = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      selectedDueDateTime!.hour,
                      selectedDueDateTime!.minute,
                    );

                    if (reminderEnabled) {
                      final int offset = reminderMinutes ?? 30;
                      final candidateReminderTime = dueTime.subtract(
                        Duration(minutes: 2),
                      );

                      // Ensure reminder time is in the future
                      reminderTime = candidateReminderTime.isAfter(now)
                          ? candidateReminderTime
                          : now.add(
                              const Duration(minutes: 1),
                            ); // fallback 1 min from now
                    }
                  }

                  final todo = Todo(
                    id: widget.todo?.id,
                    title: titleController.text.trim(),
                    description: descriptionController.text.trim(),
                    priority: _priorityToInt(selectedPriority),
                    createdAt: widget.todo?.createdAt ?? DateTime.now(),
                    dueDate: dueTime,
                    reminderTime: reminderTime,
                    isCompleted: widget.todo?.isCompleted ?? false,
                  );

                  if (widget.todo == null) {
                    context.read<TodoBloc>().add(AddTodoEvent(todo: todo));
                  } else {
                    context.read<TodoBloc>().add(UpdateTodoEvent(todo: todo));
                  }

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
