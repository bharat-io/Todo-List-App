import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list_app/model/sort/todo_sort.dart';
import 'package:todo_list_app/model/todo.dart';

class DbHelper {
  DbHelper._internal();

  static final DbHelper instance = DbHelper._internal();

  static const _dbName = 'todo.db';
  static const _tableName = 'todos';

  static const colId = 'id';
  static const colTitle = 'title';
  static const colDescription = 'description';
  static const colPriority = 'priority';
  static const colIsCompleted = 'is_completed';
  static const colCreatedAt = 'created_at';
  static const colDueDate = 'due_date';
  static const colReminderTime = 'reminder_time';

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, _dbName);

    return await openDatabase(path, version: 2, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colTitle TEXT NOT NULL,
        $colDescription TEXT,
        $colPriority INTEGER NOT NULL,
        $colCreatedAt INTEGER NOT NULL,
        $colDueDate INTEGER,
        $colReminderTime INTEGER,
        $colIsCompleted INTEGER NOT NULL
      )
    ''');
  }

  // ---------------- CRUD ----------------

  Future<int> addTodo(Todo todo) async {
    final db = await database;
    return await db.insert('todos', todo.toMap());
  }

  Future<List<Todo>> fetchTodos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    return maps.map((e) => Todo.fromMap(e)).toList();
  }

  Future<bool> updateTodo(Todo todo) async {
    final db = await database;
    final result = await db.update(
      _tableName,
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
    return result > 0;
  }

  Future<List<Todo>> fetchTodosSorted(TodoSortType sortType) async {
    final db = await database;

    String orderBy;

    switch (sortType) {
      case TodoSortType.priority:
        orderBy = '$colPriority DESC';
        break;

      case TodoSortType.dueDate:
        orderBy = '$colDueDate ASC';
        break;

      case TodoSortType.createdDate:
        orderBy = '$colCreatedAt DESC';
        break;
    }

    final maps = await db.query(_tableName, orderBy: orderBy);

    return maps.map((e) => Todo.fromMap(e)).toList();
  }
}
