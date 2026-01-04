import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService {
  Future<void> init() async {
    // Initialize the plugin
    await AwesomeNotifications().initialize(
      null, // Use default icon
      [
        NotificationChannel(
          channelKey: 'todo_channel', // Must match your notification calls
          channelName: 'Todo Notifications',
          channelDescription: 'Reminders for your todos',
          defaultColor: const Color(0xFF9D50DD),
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          playSound: true,
        ),
      ],
      debug: true,
    );
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'todo_channel', // Must match the channel key created above
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar.fromDate(date: scheduledTime),
    );
  }

  Future<void> cancelNotification(int id) async {
    await AwesomeNotifications().cancel(id);
  }
}
