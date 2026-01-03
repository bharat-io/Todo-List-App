import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_app/contorller/bloc/todo_event.dart';
import 'package:todo_list_app/contorller/bloc/todo_state.dart';
import 'package:todo_list_app/data/todo_repository.dart';
import 'package:todo_list_app/model/todo.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository repository;

  TodoBloc({required this.repository}) : super(TodoInitial()) {
    on<FetechTodoEvent>((event, emit) async {
      emit(TodoLoading());
      try {
        List<Todo> todos = await repository.fetchTodos();
        emit(TodoLoaded(todos));
      } catch (e) {
        emit(TodoFailed('Failed to load todos'));
      }
    });

    on<AddTodoEvent>((event, emit) async {
      emit(TodoLoading());
      try {
        bool isAdded = await repository.addTodo(todo: event.todo);
        if (isAdded) {
          List<Todo> todos = await repository.fetchTodos();
          emit(TodoLoaded(todos));
        } else {
          emit(TodoFailed('Todo not added!'));
        }
      } catch (e) {
        emit(TodoFailed('Error adding todo'));
      }
    });

    on<UpdateTodoEvent>((event, emit) async {
      emit(TodoLoading());

      bool isUpdated = await repository.updateTodo(todo: event.todo);

      if (isUpdated) {
        final todos = await repository.fetchTodos();
        emit(TodoLoaded(todos));
      } else {
        emit(TodoFailed('Todo not updated'));
      }
    });
  }
}
