import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_app/contorller/bloc/todo_bloc.dart';
import 'package:todo_list_app/contorller/bloc/todo_event.dart';
import 'package:todo_list_app/contorller/bloc/todo_state.dart';
import 'package:todo_list_app/model/sort/todo_sort.dart';
import 'package:todo_list_app/view/screens/add_edit_todo_screen.dart';
import 'package:todo_list_app/view/widgets/task_card.dart';

class TodoHomeScreen extends StatelessWidget {
  const TodoHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          PopupMenuButton<TodoSortType>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              context.read<TodoBloc>().add(SortTodoEvent(value));
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: TodoSortType.priority,
                child: Text('Sort by Priority'),
              ),
              PopupMenuItem(
                value: TodoSortType.dueDate,
                child: Text('Sort by Due Date'),
              ),
              PopupMenuItem(
                value: TodoSortType.createdDate,
                child: Text('Sort by Created Date'),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddEditTodoScreen()),
          );
          context.read<TodoBloc>().add(FetechTodoEvent());
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) {
                if (state is TodoLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is TodoLoaded) {
                  if (state.todos.isEmpty) {
                    return const Center(child: Text('No tasks found'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: state.todos.length,
                    itemBuilder: (context, index) {
                      final todo = state.todos[index];
                      return TaskCard(
                        onDelete: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Delete Task'),
                              content: const Text(
                                'Are you sure you want to delete this task?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.read<TodoBloc>().add(
                                      DeleteTodoEvent(todo: todo),
                                    );
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                        onToggleComplete: (value) {},
                        todo: todo,
                        onEdit: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddEditTodoScreen(todo: todo),
                            ),
                          );

                          context.read<TodoBloc>().add(FetechTodoEvent());
                        },
                      );
                    },
                  );
                }
                if (state is TodoFailed) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
