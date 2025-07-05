import 'package:first_flutter_app/ui/note/todo_screen/view_models/note_viewmodel.dart';
import 'package:first_flutter_app/ui/note/ui/todo_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListTodo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ListTodoState();
}

class _ListTodoState extends State<ListTodo> {
  
  @override
  Widget build(BuildContext context) {
    return Consumer<NoteViewModel>(
      builder: (context, viewModel, child) {
        final notes = viewModel.notes;
        return ListView(
          padding: const EdgeInsets.all(8),
          children: [
            SizedBox(height: 12),
            ...notes.map(
              (note) => Column(
                children: [
                  TodoItem(
                    category: note.category,
                    amount: note.amount.toString(),
                    description: note.description,
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
