import 'dart:convert';
import 'dart:io';

import '../../../utils/result.dart';
import 'package:first_flutter_app/config/environment.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client _client;
  final String _baseUrl;

  ApiClient({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      _baseUrl = baseUrl ?? Environment.notesApiBaseUrl;

  Future<Result<List<Map<String, dynamic>>>> fetchNote(String authToken) async {
    return _makeRequest<List<Map<String, dynamic>>>(
      method: 'GET',
      endpoint: Environment.notesEndpoint,
      authToken: authToken,
      parser: (responseData) {
        if (responseData is List) {
          return responseData.cast<Map<String, dynamic>>();
        } else {
          throw const HttpException("Invalid response format");
        }
      },
      errorMessage: "Fetch notes failed",
    );
  }

  Future<Result<Map<String, dynamic>>> fetchNoteById(
    String noteId,
    String authToken,
  ) async {
    if (noteId.isEmpty) {
      return Result.error(Exception("Note ID is required"));
    }

    return _makeRequest<Map<String, dynamic>>(
      method: 'GET',
      endpoint: '${Environment.notesEndpoint}/$noteId',
      authToken: authToken,
      parser: (responseData) {
        if (responseData is Map<String, dynamic>) {
          return responseData;
        } else {
          throw const HttpException("Invalid response format");
        }
      },
      errorMessage: "Fetch note failed",
      notFoundMessage: "Note not found: $noteId",
    );
  }

  Future<Result<Map<String, dynamic>>> createNote(
    Map<String, dynamic> noteData,
    String authToken,
  ) async {
    return _makeRequest<Map<String, dynamic>>(
      method: 'POST',
      endpoint: Environment.notesEndpoint,
      authToken: authToken,
      body: noteData,
      parser: (responseData) {
        if (responseData is Map<String, dynamic>) {
          return responseData;
        } else {
          throw const HttpException("Invalid response format");
        }
      },
      errorMessage: "Create note failed",
      successStatusCodes: [200, 201],
    );
  }

  Future<Result<Map<String, dynamic>>> updateNote(
    String noteId,
    Map<String, dynamic> noteData,
    String authToken,
  ) async {
    if (noteId.isEmpty) {
      return Result.error(Exception("Note ID is required"));
    }

    return _makeRequest<Map<String, dynamic>>(
      method: 'PATCH',
      endpoint: '${Environment.notesEndpoint}/$noteId',
      authToken: authToken,
      body: noteData,
      parser: (responseData) {
        if (responseData is Map<String, dynamic>) {
          return responseData;
        } else {
          throw const HttpException("Invalid response format");
        }
      },
      errorMessage: "Update note failed",
      notFoundMessage: "Note not found: $noteId",
    );
  }

  Future<Result<String>> deleteNote(String noteId, String authToken) async {
    if (noteId.isEmpty) {
      return Result.error(Exception("Note ID is required"));
    }

    return _makeRequest<String>(
      method: 'DELETE',
      endpoint: '${Environment.notesEndpoint}/$noteId',
      authToken: authToken,
      parser: (_) => "Success!",
      errorMessage: "Delete note failed",
      notFoundMessage: "Note not found: $noteId",
    );
  }

  Future<Result<T>> _makeRequest<T>({
    required String method,
    required String endpoint,
    required String authToken,
    required T Function(dynamic) parser,
    required String errorMessage,
    Map<String, dynamic>? body,
    List<int> successStatusCodes = const [200],
    String? notFoundMessage,
  }) async {
    try {
      if (authToken.isEmpty) {
        return Result.error(Exception("Auth token is required"));
      }

      final url = Uri.parse('$_baseUrl$endpoint');
      late http.Response response;

      switch (method.toUpperCase()) {
        case 'GET':
          response = await _client.get(url, headers: _getHeaders(authToken));
          break;
        case 'POST':
          response = await _client.post(
            url,
            headers: _getHeaders(authToken),
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'PATCH':
          response = await _client.patch(
            url,
            headers: _getHeaders(authToken),
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'DELETE':
          response = await _client.delete(url, headers: _getHeaders(authToken));
          break;
        default:
          return Result.error(Exception("Unsupported HTTP method: $method"));
      }

      return _handleResponse<T>(
        response,
        parser,
        errorMessage,
        successStatusCodes,
        notFoundMessage,
      );
    } catch (error) {
      return Result.error(Exception('$errorMessage: $error'));
    }
  }

  Map<String, String> _getHeaders(String authToken) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $authToken',
    };
  }

  Result<T> _handleResponse<T>(
    http.Response response,
    T Function(dynamic) parser,
    String errorMessage,
    List<int> successStatusCodes,
    String? notFoundMessage,
  ) {
    if (successStatusCodes.contains(response.statusCode)) {
      try {
        final responseData = response.body.isNotEmpty
            ? jsonDecode(response.body)
            : null;
        return Result.ok(parser(responseData));
      } catch (e) {
        return Result.error(Exception("Failed to parse response: $e"));
      }
    } else if (response.statusCode == 404 && notFoundMessage != null) {
      return Result.error(HttpException(notFoundMessage));
    } else {
      return Result.error(
        HttpException("$errorMessage: ${response.statusCode}"),
      );
    }
  }
}
