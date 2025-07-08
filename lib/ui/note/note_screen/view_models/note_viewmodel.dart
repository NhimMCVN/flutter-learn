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
  late final Command1<void, NoteModelUI> updateNote;
  late final Command1<void, String> deleteNote;
  late final Command0 loadNotes;

  NoteViewModel({required NoteRepository noteRepository})
    : _noteRepository = noteRepository {
    createNote = Command1<void, NoteModelUI>(_createNote);
    updateNote = Command1<void, NoteModelUI>(_updateNote);
    deleteNote = Command1<void, String>(_deleteNoteById);
    loadNotes = Command0(_loadNotes);
  }

  Future<Result<void>> _createNote(NoteModelUI note) async {
    await _noteRepository.createNote(note);
    await loadNotes.execute();
    notifyListeners();
    return const Result.ok(null);
  }

  Future<Result<void>> _updateNote(NoteModelUI note) async {
    try {
      await _noteRepository.updateNote(note.id.toString(), note);
      await loadNotes.execute();
      notifyListeners();
      return const Result.ok(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<NoteModelUI?>> getNoteById(String id) async {
    try {
      final note = await _noteRepository.fetchNoteById(id);
      _note = note;
      notifyListeners();
      return Result.ok(note);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<void>> _deleteNoteById(String id) async {
    try {
      await _noteRepository.deleteNote(id);
      await loadNotes.execute();
      notifyListeners();
      return const Result.ok(null);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<List<NoteModelUI>>> _loadNotes() async {
    try {
      final list = await _noteRepository.fetchListNote();
      _notes = list;
      notifyListeners();
      return Result.ok(list);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }
}
