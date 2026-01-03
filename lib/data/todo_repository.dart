import 'package:todo_list_app/data/local/db_helper.dart';
import 'package:todo_list_app/model/todo.dart';

class TodoRepository {
  final DbHelper dbHelper;

  TodoRepository({required this.dbHelper});

  Future<bool> addTodo({required Todo todo}) async {
    try {
      return await dbHelper.addTodo(todo);
    } catch (e) {
      return false;
    }
  }

  Future<List<Todo>> fetchTodos() async {
    return await dbHelper.fetchTodos();
  }
}
