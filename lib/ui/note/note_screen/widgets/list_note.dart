import 'package:first_flutter_app/ui/note/note_screen/view_models/note_viewmodel.dart';
import 'package:first_flutter_app/ui/note/ui/todo_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListNote extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ListNoteState();
}

class _ListNoteState extends State<ListNote> {
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
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/updateNote',
                        arguments: note.id?.toString(),
                      );
                    },
                    child: TodoItem(
                      category: note.category,
                      amount: note.amount.toString(),
                      description: note.description,
                    ),
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
