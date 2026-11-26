import 'package:flutter/material.dart';
import '../classes/app_data.dart';

// ===== SETTINGS SCREEN =====
// Lets the user change notification and planning defaults,
// and clear out tasks and to-dos that are done.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // The choices for the two dropdowns (in minutes)
  final List<int> _reminderOptions = [0, 5, 10, 15, 30, 60];
  final List<int> _postponeOptions = [5, 10, 15, 30, 60];

  String _reminderLabel(int minutes) {
    if (minutes == 0) return 'At start time';
    if (minutes == 60) return '1 hour before';
    return '$minutes min before';
  }

  String _postponeLabel(int minutes) {
    if (minutes == 60) return '1 hour';
    return '$minutes min';
  }

  // Asks first, then removes every task and to-do marked done
  Future<void> _clearCompleted() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear completed tasks?'),
        content: const Text(
            'This removes every task and to-do that is marked done.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final int removed = AppData.clearCompleted();
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(removed == 0
            ? 'Nothing to clear'
            : 'Cleared $removed completed item${removed == 1 ? '' : 's'}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ----- NOTIFICATIONS -----
          _sectionTitle('NOTIFICATIONS'),
          _card([
            CheckboxListTile(
              title: const Text('Enable notifications'),
              value: AppData.notificationsEnabled,
              onChanged: (value) =>
                  setState(() => AppData.notificationsEnabled = value ?? false),
              contentPadding: EdgeInsets.zero,
            ),
            _label('Default reminder'),
            DropdownButton<int>(
              value: AppData.defaultReminderMinutes,
              isExpanded: true,
              items: _reminderOptions
                  .map((minutes) => DropdownMenuItem<int>(
                        value: minutes,
                        child: Text(_reminderLabel(minutes)),
                      ))
                  .toList(),
              // Turned off when notifications are disabled
              onChanged: AppData.notificationsEnabled
                  ? (value) => setState(
                      () => AppData.defaultReminderMinutes = value ?? 10)
                  : null,
            ),
          ]),

          // ----- PLANNING -----
          _sectionTitle('PLANNING'),
          _card([
            _label('Default postpone length'),
            DropdownButton<int>(
              value: AppData.defaultPostponeMinutes,
              isExpanded: true,
              items: _postponeOptions
                  .map((minutes) => DropdownMenuItem<int>(
                        value: minutes,
                        child: Text(_postponeLabel(minutes)),
                      ))
                  .toList(),
              onChanged: (value) =>
                  setState(() => AppData.defaultPostponeMinutes = value ?? 15),
            ),
            const SizedBox(height: 16),
            _label('Daily time to plan: ${AppData.dailyPlanHours.round()} h'),
            Slider(
              value: AppData.dailyPlanHours,
              min: 1,
              max: 16,
              divisions: 15,
              label: '${AppData.dailyPlanHours.round()} h',
              onChanged: (value) =>
                  setState(() => AppData.dailyPlanHours = value),
            ),
          ]),

          // ----- DATA -----
          _sectionTitle('DATA'),
          _card([
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _clearCompleted,
                icon: const Icon(Icons.delete_sweep_outlined),
                label: const Text('Clear completed tasks'),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  // Small grey heading above each box
  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  // Small label above a dropdown or slider
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(text, style: const TextStyle(fontSize: 13)),
    );
  }

  // Rounded box that groups settings together
  Widget _card(List<Widget> children) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}
