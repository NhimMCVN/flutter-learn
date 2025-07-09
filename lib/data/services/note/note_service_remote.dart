import 'package:first_flutter_app/data/services/models/note_model.dart';
import 'package:first_flutter_app/data/services/models/result.dart';
import 'package:first_flutter_app/data/services/note/note_service.dart';
import 'package:first_flutter_app/data/services/api/api_client.dart';
import 'package:first_flutter_app/utils/result.dart' as utils_result;

class NoteServiceRemote extends NoteService {
  final ApiClient _apiClient;
  final String _authToken;

  final List<NoteModel> _notes = [];
  int _autoIncrementId = 0;

  NoteServiceRemote({required ApiClient apiClient, required String authToken})
    : _apiClient = apiClient,
      _authToken = authToken;

  String _generateId() {
    _autoIncrementId++;
    return _autoIncrementId.toString();
  }

  @override
  Future<Result<NoteModel>> createNote(NoteModel note) {
    final noteWithId = note.copyWith(id: _generateId());
    _notes.add(noteWithId);
    return Future.value(
      Result(message: "Create success!", statusCode: 200, data: noteWithId),
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
  Future<Result<List<NoteModel>>> getListNote() async {
    try {
      final apiResult = await _apiClient.fetchNote(_authToken);

      switch (apiResult) {
        case utils_result.Ok():
          final rawNotes = apiResult.value;

          final notes = rawNotes.map((noteJson) {
            return NoteModel(
              id: noteJson['id']?.toString(),
              description: noteJson['description'] ?? '',
              amount: (noteJson['amount'] as num?)?.toDouble() ?? 0.0,
              date: noteJson['date']?.toString() ?? '',
              category: noteJson['category'] ?? '',
              type: noteJson['type'] ?? 0,
            );
          }).toList();

          return Result(
            statusCode: 200,
            message: "Get list note success!",
            data: notes,
          );

        case utils_result.Error():
          return Result(
            statusCode: 500,
            message: "Failed to fetch notes: ${apiResult.error}",
            data: <NoteModel>[],
          );
      }
    } catch (error) {
      return Result(
        statusCode: 500,
        message: "Error fetching notes: $error",
        data: <NoteModel>[],
      );
    }
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
        Result(statusCode: 200, message: "Update success!", data: note),
      );
    }
    return Future.value(
      Result(statusCode: 404, message: "Note not found!", data: note),
    );
  }
}
