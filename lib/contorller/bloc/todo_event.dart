import 'package:todo_list_app/model/sort/todo_sort.dart';
import 'package:todo_list_app/model/todo.dart';

abstract class TodoEvent {}

class FetechTodoEvent extends TodoEvent {}

class AddTodoEvent extends TodoEvent {
  final Todo todo;

  AddTodoEvent({required this.todo});
}

class UpdateTodoEvent extends TodoEvent {
  final Todo todo;

  UpdateTodoEvent({required this.todo});
}

class SortTodoEvent extends TodoEvent {
  final TodoSortType sortType;

  SortTodoEvent(this.sortType);
}

class DeleteTodoEvent extends TodoEvent {
  final Todo todo;

  DeleteTodoEvent({required this.todo});
}

class SearchTodoEvent extends TodoEvent {
  final String query;

  SearchTodoEvent(this.query);
}
