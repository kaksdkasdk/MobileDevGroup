import 'task_object.dart';
import 'todo_item.dart';

// Holds the app's data while it is running.
// Every screen can read and change it.
// (Later this can be swapped for Firebase or Supabase.)
class AppData {
  AppData._();

  // ----- Settings -----
  static bool notificationsEnabled = true;
  static int defaultReminderMinutes = 10;
  static int defaultPostponeMinutes = 15;
  static double dailyPlanHours = 8;

  // ----- Tasks (sample tasks for today so the screens have something to show) -----
  static final List<TaskObject> tasks = [
    _sampleTask('Team meeting', 'Meeting', 9, 0, 60,
        'Bring the project outline and questions for the group.'),
    _sampleTask('Gym', 'Personal', 12, 30, 45, ''),
    _sampleTask('Laundry', 'Chore', 17, 0, 30, ''),
  ];

  // ----- To-do list -----
  static final List<TodoItem> todos = [
    TodoItem('Email professor'),
    TodoItem('Buy groceries'),
    TodoItem('Print assignment'),
    TodoItem('Call dentist'),
    TodoItem('Pay phone bill', done: true),
    TodoItem('Book gym slot', done: true),
  ];

  // Removes every task and to-do that is marked done.
  // Returns how many were removed.
  static int clearCompleted() {
    final int before = tasks.length + todos.length;
    tasks.removeWhere((task) => task.done);
    todos.removeWhere((todo) => todo.done);
    return before - (tasks.length + todos.length);
  }

  static TaskObject _sampleTask(String title, String type, int hour,
      int minute, int minutes, String notes) {
    final DateTime today = DateTime.now();
    return TaskObject()
      ..title = title
      ..type = type
      ..year = today.year
      ..month = today.month
      ..day = today.day
      ..hour = hour
      ..minute = minute
      ..timeAllocated = minutes
      ..notification = true
      ..notificationTime = 10
      ..notes = notes;
  }
}
