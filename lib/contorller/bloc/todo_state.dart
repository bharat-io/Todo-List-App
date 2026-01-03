import 'package:todo_list_app/model/todo.dart';

abstract class TodoState {}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<Todo> todos;

  TodoLoaded( this.todos);
}

class TodoFailed extends TodoState {
  final String message;

  TodoFailed(this.message);
}
