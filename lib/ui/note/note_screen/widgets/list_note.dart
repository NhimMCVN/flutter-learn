import 'package:flutter_slidable/flutter_slidable.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<NoteViewModel>(context, listen: false);
      viewModel.loadNotes.execute();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteViewModel>(
      builder: (context, viewModel, child) {
        final notes = viewModel.notes;

        if (viewModel.loadNotes.running) {
          return const Center(child: CircularProgressIndicator());
        }

        if (notes.isEmpty) {
          return const Center(
            child: Text(
              'Chưa có ghi chú nào',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(8),
          children: [
            SizedBox(height: 12),
            ...notes.map(
              (note) => Column(
                children: [
                  Slidable(
                    key: ValueKey(note.id),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            Navigator.pushNamed(
                              context,
                              '/updateNote',
                              arguments: note.id?.toString(),
                            );
                          },
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            viewModel.deleteNote.execute(note.id.toString());
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                        ),
                      ],
                    ),
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
