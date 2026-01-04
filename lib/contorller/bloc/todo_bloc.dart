import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_app/contorller/bloc/todo_event.dart';
import 'package:todo_list_app/contorller/bloc/todo_state.dart';
import 'package:todo_list_app/contorller/notification/notification_service.dart';
import 'package:todo_list_app/data/todo_repository.dart';
import 'package:todo_list_app/model/todo.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository repository;
  final NotificationService notificationService;

  TodoBloc({required this.repository, required this.notificationService})
    : super(TodoInitial()) {
    on<FetechTodoEvent>((event, emit) async {
      emit(TodoLoading());
      try {
        List<Todo> todos = await repository.fetchTodos();
        emit(TodoLoaded(todos));
      } catch (e) {
        emit(TodoFailed('Failed to load todos'));
      }
    });

    on<SearchTodoEvent>((event, emit) async {
      emit(TodoLoading());
      try {
        final allTodos = await repository.fetchTodos();
        final filtered = allTodos
            .where(
              (todo) =>
                  todo.title.toLowerCase().contains(event.query.toLowerCase()),
            )
            .toList();
        emit(TodoLoaded(filtered));
      } catch (e) {
        emit(TodoFailed('Error searching todos'));
      }
    });

    on<SortTodoEvent>((event, emit) async {
      emit(TodoLoading());
      try {
        final todos = await repository.fetchSortedTodos(event.sortType);
        emit(TodoLoaded(todos));
      } catch (e) {
        emit(TodoFailed('Failed to sort todos'));
      }
    });

    on<DeleteTodoEvent>((event, emit) async {
      await notificationService.cancelNotification(event.todo.id!);
      await notificationService.cancelNotification(event.todo.id! + 1000);

      await repository.deleteTodo(id: event.todo.id!);
      emit(TodoLoaded(await repository.fetchTodos()));
    });

    on<AddTodoEvent>((event, emit) async {
      emit(TodoLoading());

      final id = await repository.addTodo(todo: event.todo);

      if (event.todo.dueDate != null) {
        await notificationService.scheduleNotification(
          id: id,
          title: 'Task Due',
          body: event.todo.title,
          scheduledTime: event.todo.dueDate!,
        );
      }

      if (event.todo.reminderTime != null) {
        await notificationService.scheduleNotification(
          id: id + 1000,
          title: 'Reminder',
          body: 'Upcoming task: ${event.todo.title}',
          scheduledTime: event.todo.reminderTime!,
        );
      }

      final todos = await repository.fetchTodos();
      emit(TodoLoaded(todos.reversed.toList()));
    });
    on<UpdateTodoEvent>((event, emit) async {
      await repository.updateTodo(todo: event.todo);

      await notificationService.cancelNotification(event.todo.id!);
      await notificationService.cancelNotification(event.todo.id! + 1000);

      if (event.todo.dueDate != null) {
        await notificationService.scheduleNotification(
          id: event.todo.id!,
          title: 'Task Due',
          body: event.todo.title,
          scheduledTime: event.todo.dueDate!,
        );
      }

      if (event.todo.reminderTime != null) {
        await notificationService.scheduleNotification(
          id: event.todo.id! + 1000,
          title: 'Reminder',
          body: 'Upcoming task: ${event.todo.title}',
          scheduledTime: event.todo.reminderTime!,
        );
      }

      final todos = await repository.fetchTodos();
      emit(TodoLoaded(todos.reversed.toList()));
    });
  }
}
