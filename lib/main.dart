import 'package:material_ui/material_ui.dart';
import 'screens/new_task.dart';

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
                      builder: (_) => const NewTask(),
                    ),
                  );
                },
                child: const Text('View Tasks'),
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

  
