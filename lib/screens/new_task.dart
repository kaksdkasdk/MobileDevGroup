import 'package:material_ui/material_ui.dart';

const screenName = "New Task";

class NewTask extends StatelessWidget {
  const NewTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(screenName)),
      body: const SizedBox.shrink(),
    );
  }
}

