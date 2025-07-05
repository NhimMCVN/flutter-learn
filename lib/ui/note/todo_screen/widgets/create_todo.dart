import 'package:first_flutter_app/data/repositories/models/category_ui.dart';
import 'package:first_flutter_app/data/repositories/models/note_model_ui.dart';
import 'package:first_flutter_app/ui/note/todo_screen/view_models/note_viewmodel.dart';
import 'package:first_flutter_app/ui/note/ui/input_form.dart';
import 'package:first_flutter_app/ui/note/ui/category_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateTodo extends StatefulWidget {
  const CreateTodo({super.key, this.onCreated});
  final VoidCallback? onCreated;
  @override
  State<CreateTodo> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  NoteModelUI? note;
  late NoteViewModel viewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = Provider.of<NoteViewModel>(context, listen: false);
    viewModel.createNote.removeListener(_onCreateNoteCompleted);
    viewModel.createNote.addListener(_onCreateNoteCompleted);
  }

  void _onCreateNoteCompleted() {
    if (viewModel.createNote.completed) {
      widget.onCreated?.call();
    }
  }

  @override
  void dispose() {
    viewModel.createNote.removeListener(_onCreateNoteCompleted);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: InputForm(
            onChanged:
                (
                  String? description,
                  double? amount,
                  DateTime? date,
                  CategoryUI? category,
                  EnumInputMoney? inputType,
                ) {
                  note = NoteModelUI(
                    amount: amount ?? 0,
                    description: description ?? "",
                    date: date ?? DateTime.now(),
                    category:
                        category ??
                        CategoryUI(name: "", icon: Icons.help_center),
                    type: inputType == EnumInputMoney.Spending ? 0 : 1,
                  );
                },
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: ListenableBuilder(
            listenable: viewModel.createNote,
            builder: (context, child) {
              return FilledButton(
                onPressed: () {
                  print("click create ${viewModel.createNote.running}");
                  if (viewModel.createNote.running) {
                    return;
                  } else {
                    print(note);
                    if (note != null) {
                      viewModel.createNote.execute(note!);
                    }
                  }
                },
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: viewModel.createNote.running
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text("Create"),
              );
            },
          ),
        ),
      ],
    );
  }
}
