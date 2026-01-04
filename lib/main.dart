import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_app/contorller/bloc/todo_bloc.dart';
import 'package:todo_list_app/contorller/bloc/todo_event.dart';
import 'package:todo_list_app/contorller/notification/notification_service.dart';
import 'package:todo_list_app/data/local/db_helper.dart';
import 'package:todo_list_app/data/todo_repository.dart';
import 'package:todo_list_app/utill/app_color.dart';
import 'package:todo_list_app/view/screens/todo_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'todo_channel',
      channelName: 'Todo Notifications',
      channelDescription: 'Notification channel for Todo reminders',
      defaultColor: Colors.indigo,
      importance: NotificationImportance.High,
      channelShowBadge: true,
    ),
  ]);

  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowed) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final DbHelper dbHelper = DbHelper.instance;
    final NotificationService notificationService = NotificationService();

    return MultiBlocProvider(
      providers: [
        BlocProvider<TodoBloc>(
          create: (context) => TodoBloc(
            repository: TodoRepository(dbHelper: dbHelper),
            notificationService: notificationService,
          )..add(FetechTodoEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'Todo App',
        debugShowCheckedModeBanner: false,

        home: const TodoHomeScreen(),
      ),
    );
  }
}
