import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_app/contorller/bloc/todo_bloc.dart';
import 'package:todo_list_app/contorller/bloc/todo_event.dart';
import 'package:todo_list_app/data/local/db_helper.dart';
import 'package:todo_list_app/data/todo_repository.dart';
import 'package:todo_list_app/view/screens/todo_home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final DbHelper dbHelper = DbHelper.instance;

    return MultiBlocProvider(
      providers: [
        BlocProvider<TodoBloc>(
          create: (context) =>
              TodoBloc(repository: TodoRepository(dbHelper: dbHelper))
                ..add(FetechTodoEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
        home: TodoHomeScreen(),
      ),
    );
  }
}
