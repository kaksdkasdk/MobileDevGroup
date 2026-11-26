import 'package:flutter/material.dart';
import '../classes/app_data.dart';
import '../classes/task_object.dart';

// ===== TASK SCREEN =====
// Shows one task's details. The user can mark it done, edit it, or postpone it.
// Open it with:
//   Navigator.push(context, MaterialPageRoute(
//       builder: (_) => TaskDetailsScreen(task: myTask)));
class TaskDetailsScreen extends StatefulWidget {
  final TaskObject task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  static const List<String> _weekdays = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
  ];
  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  TaskObject get task => widget.task;

  DateTime get _start =>
      DateTime(task.year, task.month, task.day, task.hour, task.minute);

  DateTime get _end => _start.add(Duration(minutes: task.timeAllocated));

  String _formatDate(DateTime d) =>
      '${_weekdays[d.weekday - 1]}, ${_months[d.month - 1]} ${d.day}, ${d.year}';

  String _formatTime(DateTime d) =>
      '${d.hour}:${d.minute.toString().padLeft(2, '0')}';

  String get _notificationText {
    if (!task.notification) return 'Off';
    if (task.notificationTime == 0) return 'At start time';
    return '${task.notificationTime} min before';
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  // Mark done / not done
  void _toggleDone() {
    setState(() => task.done = !task.done);
    _showMessage(task.done ? 'Marked as done' : 'Marked as not done');
  }

  // Move the task later by the default postpone length from Settings
  void _postpone() {
    final DateTime newStart =
        _start.add(Duration(minutes: AppData.defaultPostponeMinutes));
    setState(() {
      task.year = newStart.year;
      task.month = newStart.month;
      task.day = newStart.day;
      task.hour = newStart.hour;
      task.minute = newStart.minute;
    });
    _showMessage(
        'Postponed ${AppData.defaultPostponeMinutes} min to ${_formatTime(newStart)}');
  }

  // Opens a small box to change the title and notes
  Future<void> _edit() async {
    final ({String title, String notes})? result =
        await showDialog<({String title, String notes})>(
      context: context,
      builder: (_) => _EditTaskDialog(title: task.title, notes: task.notes),
    );
    if (result == null || !mounted) return;
    setState(() {
      task.title = result.title;
      task.notes = result.notes;
    });
    _showMessage('Task updated');
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Task')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and type tag
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            decoration:
                                task.done ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ),
                      Chip(label: Text(task.type.isEmpty ? 'Task' : task.type)),
                    ],
                  ),
                  if (task.done)
                    Text('Done ✓',
                        style: TextStyle(
                            color: colors.primary, fontWeight: FontWeight.bold)),
                  const Divider(height: 24),
                  _infoRow('Date', _formatDate(_start)),
                  _infoRow('Time', '${_formatTime(_start)} – ${_formatTime(_end)}'),
                  _infoRow('Allocated', '${task.timeAllocated} min'),
                  _infoRow('Notification', _notificationText),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('NOTES',
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
          const SizedBox(height: 8),
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(task.notes.isEmpty ? 'No notes' : task.notes),
            ),
          ),
        ],
      ),

      // Buttons at the bottom
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: _toggleDone,
                  child: Text(task.done ? 'Mark not done' : 'Mark done'),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _edit,
                      child: const Text('Edit'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _postpone,
                      child: const Text('Postpone'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // One line of info: label on the left, value on the right
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// The pop-up box used by Edit
class _EditTaskDialog extends StatefulWidget {
  final String title;
  final String notes;

  const _EditTaskDialog({required this.title, required this.notes});

  @override
  State<_EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<_EditTaskDialog> {
  late final TextEditingController _titleController =
      TextEditingController(text: widget.title);
  late final TextEditingController _notesController =
      TextEditingController(text: widget.notes);

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Task'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(labelText: 'Notes'),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final String title = _titleController.text.trim();
            if (title.isEmpty) return;
            Navigator.pop(context,
                (title: title, notes: _notesController.text.trim()));
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
