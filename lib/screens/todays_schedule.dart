import 'package:material_ui/material_ui.dart';

const screenName = 'Today\'s Schedule';

// class CalanderScreen extends StatefulWidget {
//   const CalanderScreen({super.key});

//   @override
//   State<CalanderScreen> createState() => _CalanderScreenState();
// }

class TodaySchedule extends StatelessWidget {
  const TodaySchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(screenName)),
      body: const SizedBox.shrink(),
    );
  }
}