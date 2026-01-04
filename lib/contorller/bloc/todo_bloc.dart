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
      emit(TodoLoading());
      try {
        final isDeleted = await repository.deleteTodo(id: event.todo.id!);
        if (isDeleted) {
          final todos = await repository.fetchTodos();
          emit(TodoLoaded(todos));
        } else {
          emit(TodoFailed('Todo not deleted'));
        }
      } catch (e) {
        emit(TodoFailed('Error deleting todo'));
      }
    });

    on<AddTodoEvent>((event, emit) async {
      emit(TodoLoading());
      try {
        final int insertedId = await repository.addTodo(todo: event.todo);

        if (event.todo.reminderTime != null) {
          await notificationService.scheduleNotification(
            id: insertedId,
            title: 'Task Reminder',
            body: event.todo.title,
            scheduledTime: event.todo.reminderTime!,
          );
        }

        final todos = await repository.fetchTodos();
        emit(TodoLoaded(todos));
      } catch (e) {
        emit(TodoFailed('Error adding todo: $e'));
        print("Error: $e");
      }
    });

    on<UpdateTodoEvent>((event, emit) async {
      emit(TodoLoading());

      bool isUpdated = await repository.updateTodo(todo: event.todo);

      if (isUpdated) {
        if (event.todo.reminderTime != null) {
          await notificationService.scheduleNotification(
            id: event.todo.id!,
            title: 'Task Reminder',
            body: event.todo.title,
            scheduledTime: event.todo.reminderTime!,
          );
        } else {
          await notificationService.cancelNotification(event.todo.id!);
        }
        final todos = await repository.fetchTodos();
        emit(TodoLoaded(todos));
      } else {
        emit(TodoFailed('Todo not updated'));
      }
    });
  }
}
