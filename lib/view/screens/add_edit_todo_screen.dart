import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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

  DateTime? selectedDueDateTime;
  int reminderMinutes = 30;
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

    int numericPriority = widget.todo?.priority ?? 2;
    if (![1, 2, 3].contains(numericPriority)) numericPriority = 2;
    selectedPriority = _priorityToString(numericPriority);

    selectedDueDateTime = widget.todo?.dueDate;

    reminderEnabled = widget.todo?.reminderTime != null;
    if (widget.todo?.reminderTime != null) {
      final due = widget.todo!.dueDate;
      final reminder = widget.todo!.reminderTime!;
      if (due != null) {
        final diff = due.difference(reminder).inMinutes;
        reminderMinutes = reminderOptions.any((e) => e.values.first == diff)
            ? diff
            : 30;
      } else {
        reminderMinutes = 30;
      }
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
            TextField(
              controller: titleController,
              decoration: commonDecoration('Title'),
            ),

            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: commonDecoration('Description'),
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
              onChanged: (value) => setState(() => selectedPriority = value!),
              decoration: const InputDecoration(
                labelText: 'Priority',
                labelStyle: TextStyle(color: Colors.white),

                filled: true,
                fillColor: Colors.transparent,

                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                ),
              ),
            ),

            const SizedBox(height: 16),

            ListTile(
              title: Text(
                selectedDueDateTime == null
                    ? 'Select Due Time'
                    : 'Due at: ${DateFormat('dd MMM yyyy, hh:mm a').format(selectedDueDateTime!)}',
              ),
              trailing: const Icon(Icons.access_time),
              onTap: pickDueDateTime,
            ),

            if (selectedDueDateTime != null)
              SwitchListTile(
                title: const Text('Set Reminder'),
                value: reminderEnabled,
                onChanged: (value) => setState(() => reminderEnabled = value),
                activeColor: Colors.white,
                inactiveThumbColor: Colors.white,
              ),
            const SizedBox(height: 16),

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
                onChanged: (value) => setState(() => reminderMinutes = value!),
                decoration: const InputDecoration(
                  labelText: 'Reminder Time',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.transparent,

                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  if (titleController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Title is required')),
                    );
                    return;
                  }

                  DateTime? dueTime = selectedDueDateTime;
                  DateTime? reminderTime;

                  if (selectedDueDateTime != null && reminderEnabled) {
                    final candidate = selectedDueDateTime!.subtract(
                      Duration(minutes: reminderMinutes),
                    );
                    reminderTime = candidate.isAfter(DateTime.now())
                        ? candidate
                        : DateTime.now().add(const Duration(minutes: 1));
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

                  if (isEdit) {
                    context.read<TodoBloc>().add(UpdateTodoEvent(todo: todo));
                  } else {
                    context.read<TodoBloc>().add(AddTodoEvent(todo: todo));
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

  InputDecoration commonDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white),
      border: const OutlineInputBorder(),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 1),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 2),
      ),
    );
  }
}
