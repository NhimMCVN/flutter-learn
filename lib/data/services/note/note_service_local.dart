import 'package:first_flutter_app/data/services/models/note_model.dart';
import 'package:first_flutter_app/data/services/models/result.dart';
import 'package:first_flutter_app/data/services/note/note_service.dart';

class NoteServiceLocal extends NoteService {
  final List<NoteModel> _notes = [];

  @override
  Future<Result<NoteModel>> createNote(NoteModel note) {
    _notes.add(note);
    return Future.value(
      Result(message: "Create success!", statusCode: 200, data: note),
    );
  }

  @override
  Future<Result> deleteNote(String id) {
    final index = _notes.indexWhere((element) => element.id == id);
    if (index != -1) {
      _notes.removeAt(index);
    }
    return Future.value(Result(statusCode: 200, message: "Delete success!"));
  }

  @override
  Future<Result<List<NoteModel>>> getListNote() {
    return Future.value(
      Result(statusCode: 200, message: "Get list note success!", data: _notes),
    );
  }

  @override
  Future<Result<NoteModel?>> getNoteById(String id) {
    final index = _notes.indexWhere((element) => element.id == id);
    if (index != -1) {
      return Future.value(
        Result(
          statusCode: 200,
          message: "Get note success!",
          data: _notes[index],
        ),
      );
    }
    return Future.value(Result(message: "Note is not found!", statusCode: 200));
  }

  @override
  Future<Result<NoteModel>> updateNote(NoteModel note) {
    final index = _notes.indexWhere((element) => element.id == note.id);
    if (index != -1) {
      _notes[index] = note;
      return Future.value(
        Result(
          statusCode: 200,
          message: "Update success!",
          data: note,
        ),
      );
    }
    return Future.value(
      Result(
        statusCode: 404,
        message: "Note not found!",
        data: note,
      ),
    );
  }
}
