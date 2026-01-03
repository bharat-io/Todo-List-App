import 'package:todo_list_app/model/todo.dart';

abstract class TodoEvent {}

class FetechTodoEvent extends TodoEvent {}

class AddTodoEvent extends TodoEvent {
  final Todo todo;

  AddTodoEvent({required this.todo});
}
