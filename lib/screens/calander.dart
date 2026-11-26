import 'package:flutter/material.dart';

const screenName = 'Calendar';

// class CalanderScreen extends StatefulWidget {
//   const CalanderScreen({super.key});

//   @override
//   State<CalanderScreen> createState() => _CalanderScreenState();
// }

class CalenderScreen extends StatelessWidget {
  const CalenderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(screenName)),
      body: const SizedBox.shrink(),
    );
  }
}