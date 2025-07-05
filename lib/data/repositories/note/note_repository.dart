import 'package:first_flutter_app/data/repositories/models/note_model_ui.dart';

abstract class NoteRepository {
  Future<dynamic> fetchListNote();
  Future<dynamic> fetchNoteById(String id);
  Future<dynamic> createNote(NoteModelUI note);
  Future<dynamic> updateNote(String id, NoteModelUI note);
  Future<dynamic> deleteNote(String id);
}