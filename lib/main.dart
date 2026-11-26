import 'package:flutter/material.dart';
import 'screens/calander.dart';
import 'screens/new_task.dart';
import 'screens/todays_schedule.dart';
import 'screens/settings.dart';
import 'screens/task_details.dart';
import 'screens/todo.dart';
import 'classes/app_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final colors = ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Planner',
      theme: ThemeData(
        colorScheme: colors,
        appBarTheme: AppBarTheme(
          backgroundColor: colors.inversePrimary,
        
        ),
      ),
      home: const MyHomePage(title: 'My planner'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  

  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        
        title: Text(widget.title),
        actions: [
          // To-do screen
          IconButton(
            tooltip: 'To-do',
            icon: const Icon(Icons.checklist),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const TodoScreen()),
              );
            },
          ),
          // TEMP: opens the first task so the Task screen can be tested.
          // Remove this once Today's Schedule / Calendar open tasks.
          IconButton(
            tooltip: 'Task (sample)',
            icon: const Icon(Icons.event_note),
            onPressed: () {
              if (AppData.tasks.isEmpty) return;
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => TaskDetailsScreen(task: AppData.tasks.first),
                ),
              );
            },
          ),
          // Settings screen
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),

      body: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const TodaySchedule(),
                    ),
                  );
                },
                child: const Text('View Today\'s Tasks'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const CalenderScreen(),
                    ),
                  );
                },
                child: const Text('Calendar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const NewTask(),
                    ),
                  );
                },
                child: const Text('+  Add Tasks'),
              ),
            ],
          ),
        ),
      ),
      
    );
  }
}

  
