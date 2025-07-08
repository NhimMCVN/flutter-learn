import 'package:first_flutter_app/data/repositories/models/category_ui.dart';
import 'package:first_flutter_app/data/repositories/models/note_model_ui.dart';
import 'package:first_flutter_app/ui/note/note_screen/view_models/note_viewmodel.dart';
import 'package:first_flutter_app/ui/note/ui/category_item.dart';
import 'package:first_flutter_app/ui/note/ui/input_form.dart';
import 'package:first_flutter_app/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateNote extends StatefulWidget {
  final String id;

  UpdateNote({super.key, required this.id});

  @override
  State<UpdateNote> createState() => _UpdateNoteState();
}

class _UpdateNoteState extends State<UpdateNote> {
  NoteModelUI? note;
  late NoteViewModel viewModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel = Provider.of<NoteViewModel>(context, listen: false);
    fetchNoteById();
    viewModel.updateNote.removeListener(_onUpdateCompleted);
    viewModel.updateNote.addListener(_onUpdateCompleted);
  }

  void _onUpdateCompleted() {
    if (viewModel.updateNote.completed) {
      Navigator.of(context).pop();
    }
  }

  void fetchNoteById() async {
    final result = await viewModel.getNoteById(widget.id);
    if (result is Ok<NoteModelUI?>) {
      final resultNote = result.value;
      setState(() {
        note = resultNote;
      });
    } else if (result is Error) {}
  }

  void handleChangeForm(
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
      category: category ?? CategoryUI(name: "", icon: Icons.help_center),
      type: inputType == EnumInputMoney.Spending ? 0 : 1,
      id: note?.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text(
        "Update",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.deepPurple,
    ),
      body: Column(
        children: [
          Expanded(
            child: InputForm(
              onChanged: handleChangeForm,
              initDescription: note?.description ?? "",
              initAmount: note?.amount ?? 0,
              initDate:
                  note?.date?.toIso8601String() ??
                  DateTime.now().toIso8601String(),
              initCate: note?.category,
              type: note?.type == 0
                  ? EnumInputMoney.Spending
                  : EnumInputMoney.Revenue,
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ListenableBuilder(
              listenable: viewModel.updateNote,
              builder: (context, child) {
                return FilledButton(
                  onPressed: () {
                    if (viewModel.updateNote.running) {
                      return;
                    } else {
                      if (note != null) {
                        viewModel.updateNote.execute(note!);
                      }
                    }
                  },
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: viewModel.updateNote.running
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text("update"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
