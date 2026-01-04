import 'package:todo_list_app/data/local/db_helper.dart';
import 'package:todo_list_app/model/todo.dart';

class TodoRepository {
  final DbHelper dbHelper;

  TodoRepository({required this.dbHelper});

  Future<int> addTodo({required Todo todo}) async {
    final db = await dbHelper.database;
    final id = await db.insert('todos', todo.toMap());
    return id;
  }

  Future<List<Todo>> fetchTodos() async {
    return await dbHelper.fetchTodos();
  }

  Future<bool> updateTodo({required Todo todo}) async {
    try {
      return await dbHelper.updateTodo(todo);
    } catch (e) {
      throw Exception('Failed to update todo');
    }
  }
}
