import 'package:flutter/material.dart';
import '../classes/app_data.dart';
import '../classes/todo_item.dart';

// ===== TO-DO SCREEN =====
// Add quick to-dos, check them off, and swipe left to delete.
class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Add a new to-do from the text box
  void _add() {
    final String text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() => AppData.todos.add(TodoItem(text)));
    _controller.clear();
  }

  // Check or uncheck a to-do
  void _toggle(TodoItem item, bool? value) {
    setState(() => item.done = value ?? false);
  }

  // Delete a to-do (with an Undo button)
  void _delete(TodoItem item) {
    final int index = AppData.todos.indexOf(item);
    setState(() => AppData.todos.remove(item));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted "${item.title}"'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => setState(() => AppData.todos.insert(index, item)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<TodoItem> toDo = AppData.todos.where((t) => !t.done).toList();
    final List<TodoItem> done = AppData.todos.where((t) => t.done).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('To-do')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Text box + Add button
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Add a to-do',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _add(),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(onPressed: _add, child: const Text('Add')),
            ],
          ),
          const SizedBox(height: 6),
          const Text('Tip: swipe left on a to-do to delete it',
              style: TextStyle(fontSize: 12, color: Colors.grey)),

          _sectionTitle('TO DO (${toDo.length})'),
          toDo.isEmpty ? _emptyText('Nothing left to do!') : _listCard(toDo),

          _sectionTitle('DONE (${done.length})'),
          done.isEmpty ? _emptyText('Nothing done yet') : _listCard(done),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
      child: Text(text,
          style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
    );
  }

  Widget _emptyText(String text) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(text, style: const TextStyle(color: Colors.grey)),
    );
  }

  // A box holding a list of to-dos
  Widget _listCard(List<TodoItem> items) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _todoTile(items[i]),
            if (i < items.length - 1) const Divider(height: 1),
          ],
        ],
      ),
    );
  }

  // One to-do row with a check box
  Widget _todoTile(TodoItem item) {
    return Dismissible(
      key: ObjectKey(item),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => _delete(item),
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        value: item.done,
        onChanged: (value) => _toggle(item, value),
        title: Text(
          item.title,
          style: item.done
              ? const TextStyle(
                  decoration: TextDecoration.lineThrough, color: Colors.grey)
              : null,
        ),
      ),
    );
  }
}
