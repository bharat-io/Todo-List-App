import 'package:flutter_bloc/flutter_bloc.dart';

import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitial()) {
    on<AddTodoEvent>((event, emit) {
      emit(TodoLoading());
    });
  }
}
