import 'package:first_flutter_app/data/services/models/note_model.dart';
import 'package:first_flutter_app/data/services/models/result.dart';
import 'package:first_flutter_app/data/services/note/note_service.dart';
import 'package:first_flutter_app/data/services/api/api_client.dart';
import 'package:first_flutter_app/data/services/shared_preferences_service.dart';
import 'package:first_flutter_app/utils/result.dart' as utils_result;

class NoteServiceLocal extends NoteService {
  final ApiClient _apiClient;
  final String _authToken;
  final SharedPreferencesService _sharedPreferencesService;

  NoteServiceLocal({
    required ApiClient apiClient,
    required String authToken,
    required SharedPreferencesService sharedPreferencesService,
  }) : _apiClient = apiClient,
       _authToken = authToken,
       _sharedPreferencesService = sharedPreferencesService;

  @override
  Future<Result<NoteModel>> createNote(NoteModel note) async {
    try {
      String authToken = _authToken;
      if (authToken.isEmpty) {
        final tokenResult = await _sharedPreferencesService.fetchToken();

        switch (tokenResult) {
          case utils_result.Ok<String?>():
            authToken = tokenResult.value ?? '';
            break;
          case utils_result.Error<String?>():
            return Result(
              statusCode: 401,
              message: "No auth token available",
              data: note,
            );
        }
      }

      if (authToken.isEmpty) {
        return Result(
          statusCode: 401,
          message: "Please login first",
          data: note,
        );
      }

      // Prepare payload for API
      final noteData = {
        'category': note.category,
        'amount': note.amount,
        'description': note.description,
        'date': note.date,
        'type': note.type,
      };

      final apiResult = await _apiClient.createNote(noteData, authToken);

      switch (apiResult) {
        case utils_result.Ok():
          final responseJson = apiResult.value;

          final createdNote = NoteModel(
            id: responseJson['id']?.toString(),
            description: responseJson['description'] ?? '',
            amount: (responseJson['amount'] as num?)?.toDouble() ?? 0.0,
            date: (responseJson['date'] as num?)?.toDouble() ?? 0.0,
            category: responseJson['category'] ?? '',
            type: responseJson['type'] ?? 0,
          );

          return Result(
            statusCode: 200,
            message: "Create note success!",
            data: createdNote,
          );

        case utils_result.Error():
          return Result(
            statusCode: 500,
            message: "Failed to create note: ${apiResult.error}",
            data: note,
          );
      }
    } catch (error) {
      return Result(
        statusCode: 500,
        message: "Error creating note: $error",
        data: note,
      );
    }
  }

  @override
  Future<Result> deleteNote(String id) async {
    try {
      String authToken = _authToken;
      if (authToken.isEmpty) {
        final tokenResult = await _sharedPreferencesService.fetchToken();

        switch (tokenResult) {
          case utils_result.Ok<String?>():
            authToken = tokenResult.value ?? '';
            break;
          case utils_result.Error<String?>():
            return Result(statusCode: 401, message: "No auth token available");
        }
      }

      if (authToken.isEmpty) {
        return Result(statusCode: 401, message: "Please login first");
      }

      final apiResult = await _apiClient.deleteNote(id, authToken);

      switch (apiResult) {
        case utils_result.Ok():
          return Result(statusCode: 200, message: "Delete note success!");

        case utils_result.Error():
          return Result(
            statusCode: 500,
            message: "Failed to delete note: ${apiResult.error}",
          );
      }
    } catch (error) {
      return Result(statusCode: 500, message: "Error deleting note: $error");
    }
  }

  @override
  Future<Result<List<NoteModel>>> getListNote() async {
    try {
      String authToken = _authToken;
      if (authToken.isEmpty) {
        final tokenResult = await _sharedPreferencesService.fetchToken();

        switch (tokenResult) {
          case utils_result.Ok<String?>():
            authToken = tokenResult.value ?? '';
            break;
          case utils_result.Error<String?>():
            return Result(
              statusCode: 401,
              message: "No auth token available",
              data: <NoteModel>[],
            );
        }
      }

      if (authToken.isEmpty) {
        return Result(
          statusCode: 401,
          message: "Please login first",
          data: <NoteModel>[],
        );
      }

      final apiResult = await _apiClient.fetchNote(authToken);

      switch (apiResult) {
        case utils_result.Ok():
          final rawNotes = apiResult.value;

          final notes = rawNotes.map((noteJson) {
            return NoteModel(
              id: noteJson['id']?.toString(),
              description: noteJson['description'] ?? '',
              amount: (noteJson['amount'] as num?)?.toDouble() ?? 0.0,
              date: (noteJson['date'] as num?)?.toDouble() ?? 0.0,
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
  Future<Result<NoteModel?>> getNoteById(String id) async {
    try {
      String authToken = _authToken;
      if (authToken.isEmpty) {
        final tokenResult = await _sharedPreferencesService.fetchToken();

        switch (tokenResult) {
          case utils_result.Ok<String?>():
            authToken = tokenResult.value ?? '';
            break;
          case utils_result.Error<String?>():
            return Result(
              statusCode: 401,
              message: "No auth token available",
              data: null,
            );
        }
      }

      if (authToken.isEmpty) {
        return Result(
          statusCode: 401,
          message: "Please login first",
          data: null,
        );
      }

      final apiResult = await _apiClient.fetchNoteById(id, authToken);

      switch (apiResult) {
        case utils_result.Ok():
          final noteJson = apiResult.value;

          final note = NoteModel(
            id: noteJson['id']?.toString(),
            description: noteJson['description'] ?? '',
            amount: (noteJson['amount'] as num?)?.toDouble() ?? 0.0,
            date: (noteJson['date'] as num?)?.toDouble() ?? 0.0,
            category: noteJson['category'] ?? '',
            type: noteJson['type'] ?? 0,
          );

          return Result(
            statusCode: 200,
            message: "Get note success!",
            data: note,
          );

        case utils_result.Error():
          return Result(
            statusCode: 404,
            message: "Note not found: ${apiResult.error}",
            data: null,
          );
      }
    } catch (error) {
      return Result(
        statusCode: 500,
        message: "Error fetching note: $error",
        data: null,
      );
    }
  }

  @override
  Future<Result<NoteModel>> updateNote(NoteModel note) async {
    try {
      String authToken = _authToken;
      if (authToken.isEmpty) {
        final tokenResult = await _sharedPreferencesService.fetchToken();

        switch (tokenResult) {
          case utils_result.Ok<String?>():
            authToken = tokenResult.value ?? '';
            break;
          case utils_result.Error<String?>():
            return Result(
              statusCode: 401,
              message: "No auth token available",
              data: note,
            );
        }
      }

      if (authToken.isEmpty) {
        return Result(
          statusCode: 401,
          message: "Please login first",
          data: note,
        );
      }

      if (note.id == null || note.id!.isEmpty) {
        return Result(
          statusCode: 400,
          message: "Note ID is required for update",
          data: note,
        );
      }

      // Prepare payload for API
      final noteData = {
        'category': note.category,
        'amount': note.amount,
        'description': note.description,
        'date': note.date,
        'type': note.type,
      };

      final apiResult = await _apiClient.updateNote(
        note.id!,
        noteData,
        authToken,
      );

      switch (apiResult) {
        case utils_result.Ok():
          final responseJson = apiResult.value;

          final updatedNote = NoteModel(
            id: responseJson['id']?.toString(),
            description: responseJson['description'] ?? '',
            amount: (responseJson['amount'] as num?)?.toDouble() ?? 0.0,
            date: (responseJson['date'] as num?)?.toDouble() ?? 0.0,
            category: responseJson['category'] ?? '',
            type: responseJson['type'] ?? 0,
          );

          return Result(
            statusCode: 200,
            message: "Update note success!",
            data: updatedNote,
          );

        case utils_result.Error():
          return Result(
            statusCode: 500,
            message: "Failed to update note: ${apiResult.error}",
            data: note,
          );
      }
    } catch (error) {
      return Result(
        statusCode: 500,
        message: "Error updating note: $error",
        data: note,
      );
    }
  }
}
