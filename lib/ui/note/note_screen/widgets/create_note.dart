import 'package:first_flutter_app/data/repositories/models/category_ui.dart';
import 'package:first_flutter_app/data/repositories/models/note_model_ui.dart';
import 'package:first_flutter_app/ui/note/note_screen/view_models/note_viewmodel.dart';
import 'package:first_flutter_app/ui/note/ui/input_form.dart';
import 'package:first_flutter_app/ui/note/ui/category_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateNote extends StatefulWidget {
  const CreateNote({super.key, this.onCreated});
  final VoidCallback? onCreated;
  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
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

  bool _validateNote() {
    if (note == null) {
      _showErrorSnackBar("Please fill in all required fields");
      return false;
    }

    if (note!.description.trim().isEmpty) {
      _showErrorSnackBar("Please enter a description");
      return false;
    }

    if (note!.amount <= 0) {
      _showErrorSnackBar("Please enter a valid amount");
      return false;
    }

    if (note!.category.name.isEmpty) {
      _showErrorSnackBar("Please select a category");
      return false;
    }

    return true;
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
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
                  if (viewModel.createNote.running) {
                    return;
                  } else {
                    if (_validateNote()) {
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
