# 📝 Todo List App (Flutter)

A production-ready **Todo List application built with Flutter**, using **BLoC state management**, **SQLite (sqflite) local database**, and **local notifications**.  
This project demonstrates **clean architecture**, **offline-first design**, and **real-world Flutter best practices**, suitable for technical interviews.

---

## 🚀 Features

### ✅ Core Functionality
- Add new Todo tasks
- Edit existing tasks
- Delete tasks
- Mark tasks as **Completed / Incomplete**
- Completed task title shows **strikethrough**
- Newly added tasks appear **on top of the list**
- Real-time task search
- Works completely **offline**

### ⭐ Priority Management
- Priority levels:
  - Low
  - Medium
  - High
- Priority selection during Add/Edit
- Priority preserved correctly while editing

### ⏰ Reminders & Notifications
- Due date notifications
- Reminder notifications (5 min, 30 min, 1 hour, 1 day)
- Notification permission requested on **first app launch**
- Notifications work even when the app is closed or killed
- Exact alarms handled correctly (Android 12+)

---

## 🧠 Architecture

The app follows a **clean MVC-style architecture combined with BLoC**, ensuring scalability and maintainability.


---

## 🗄️ Local Database (SQLite)

- **sqflite** is used for persistent local storage
- CRUD operations:
  - Insert Todo
  - Update Todo
  - Delete Todo
  - Fetch all Todos
- Offline-first architecture
- Data remains intact after app restart
- Database layer isolated using Repository pattern

---

## 🔁 State Management (BLoC)

**flutter_bloc** is used for predictable and testable state handling.

### Events
- AddTodoEvent
- UpdateTodoEvent
- DeleteTodoEvent
- ToggleCompleteTodoEvent
- SearchTodoEvent

### States
- TodoInitial
- TodoLoading
- TodoLoaded
- TodoError

---

## 🔔 Notifications

- Implemented using **flutter_local_notifications**
- Supports:
  - Scheduled reminders
  - Due date alerts
  - Exact alarm scheduling
- Linked with SQLite Todo IDs for reliability

---

## 🎨 UI & Theme

Custom color palette used across the app:

```dart
const Color backgroundColor = Color(0xff344FA1);
const Color lightBlue = Color(0xffA1C0F8);
const Color cardColor = Color(0xff031956);
const Color accentColor = Color(0xffEB05FF);


| Package                     | Version |
| --------------------------- | ------- |
| flutter_bloc                | ^8.1.3  |
| equatable                   | ^2.0.5  |
| sqflite                     | ^2.3.0  |
| path                        | ^1.9.0  |
| flutter_local_notifications | ^17.0.0 |
| intl                        | ^0.19.0 |


<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>

flutter pub get
flutter run

