import 'package:first_flutter_app/data/repositories/models/note_model_ui.dart';
import 'package:first_flutter_app/data/repositories/note/note_repository.dart';
import 'package:first_flutter_app/utils/command.dart';
import 'package:first_flutter_app/utils/result.dart';
import 'package:flutter/material.dart';

class NoteViewModel extends ChangeNotifier {
  final NoteRepository _noteRepository;
  NoteModelUI? _note;
  NoteModelUI? get note => _note;
  List<NoteModelUI> _notes = [];
  List<NoteModelUI> get notes => _notes;

  late final Command1<void, NoteModelUI> createNote;
  late final Command0 loadNotes;

  NoteViewModel({required NoteRepository noteRepository})
    : _noteRepository = noteRepository {
    createNote = Command1<void, NoteModelUI>(_createNote);
    loadNotes = Command0(_loadNotes);
  }

  Future<Result<void>> _createNote(NoteModelUI note) async {
    Future.delayed(Duration(seconds: 2));
    await _noteRepository.createNote(note);
    await loadNotes.execute();
    notifyListeners();
    return const Result.ok(null);
  }

  Future<Result<List<NoteModelUI>>> _loadNotes() async {
    try {
      final list = await _noteRepository
          .fetchListNote(); 
      _notes = list;
      notifyListeners();
      return Result.ok(list);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }
}
