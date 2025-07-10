import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:first_flutter_app/ui/note/note_screen/view_models/note_viewmodel.dart';
import 'package:first_flutter_app/ui/note/ui/todo_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Loading notes...',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        if (notes.isEmpty) {
          return const Center(
            child: Text(
              'No notes yet',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return Stack(
          children: [
            ListView(
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
                              onPressed: viewModel.deleteNote.running
                                  ? null
                                  : (context) {
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
                              onPressed: viewModel.deleteNote.running
                                  ? null
                                  : (context) {
                                      viewModel.deleteNote.execute(
                                        note.id.toString(),
                                      );
                                    },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                            ),
                          ],
                        ),
                        child: TodoItem(
                          category: note.category,
                          amount: note.type == 0
                              ? '-\$${NumberFormat('#,###').format(note.amount)}'
                              : '+\$${NumberFormat('#,###').format(note.amount)}',
                          amountColor: note.type == 0
                              ? Colors.red
                              : Colors.green,
                          description: note.description,
                        ),
                      ),
                      SizedBox(height: 12),
                    ],
                  ),
                ),
              ],
            ),
            if (viewModel.deleteNote.running)
              Container(
                color: Colors.black26,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'Deleting note...',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
