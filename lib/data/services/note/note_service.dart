import 'package:first_flutter_app/data/services/models/note_model.dart';

abstract class NoteService {
  Future<void> getListNote();
  Future<void> getNoteById(String id);
  Future<void> createNote(NoteModel note);
  Future<void> updateNote(NoteModel note);
  Future<void> deleteNote(String id);
}