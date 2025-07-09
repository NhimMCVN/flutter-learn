// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import '../../../utils/result.dart';
import 'package:http/http.dart' as http;

/// Adds the `Authentication` header to a header configuration.
typedef AuthHeaderProvider = String? Function();

class ApiClient {
  ApiClient({String? host, http.Client? client})
    : _baseUrl = host ?? 'localhost',
      _client = client ?? http.Client();

  final String _baseUrl;
  final http.Client _client;
  Future<Result<List<Map<String, dynamic>>>> fetchNote(String authToken) async {
    try {
      if (authToken.isEmpty) {
        return Result.error(Exception("Auth token is required"));
      }

      final notesUrl = '$_baseUrl/note';

      final response = await _client.get(
        Uri.parse(notesUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData is List) {
          final notes = responseData.cast<Map<String, dynamic>>();
          return Result.ok(notes);
        } else {
          return const Result.error(HttpException("Invalid response format"));
        }
      } else {
        return Result.error(
          HttpException("Fetch notes failed: ${response.statusCode}"),
        );
      }
    } catch (error) {
      return Result.error(Exception('Fetch notes failed: $error'));
    }
  }

  Future<Result<Map<String, dynamic>>> fetchNoteById(
    String noteId,
    String authToken,
  ) async {
    try {
      if (authToken.isEmpty) {
        return Result.error(Exception("Auth token is required"));
      }

      if (noteId.isEmpty) {
        return Result.error(Exception("Note ID is required"));
      }

      final noteUrl = '$_baseUrl/note/$noteId';

      final response = await _client.get(
        Uri.parse(noteUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData is Map<String, dynamic>) {
          return Result.ok(responseData);
        } else {
          return const Result.error(HttpException("Invalid response format"));
        }
      } else if (response.statusCode == 404) {
        return Result.error(HttpException("Note not found: $noteId"));
      } else {
        return Result.error(
          HttpException("Fetch note failed: ${response.statusCode}"),
        );
      }
    } catch (error) {
      return Result.error(Exception('Fetch note by ID failed: $error'));
    }
  }

  Future<Result<Map<String, dynamic>>> createNote(
    Map<String, dynamic> noteData,
    String authToken,
  ) async {
    try {
      if (authToken.isEmpty) {
        return Result.error(Exception("Auth token is required"));
      }

      final notesUrl = '$_baseUrl/note';

      final response = await _client.post(
        Uri.parse(notesUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(noteData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        if (responseData is Map<String, dynamic>) {
          return Result.ok(responseData);
        } else {
          return const Result.error(HttpException("Invalid response format"));
        }
      } else {
        return Result.error(
          HttpException("Create note failed: ${response.statusCode}"),
        );
      }
    } catch (error) {
      return Result.error(Exception('Create note failed: $error'));
    }
  }

  Future<Result<Map<String, dynamic>>> updateNote(
    String noteId,
    Map<String, dynamic> noteData,
    String authToken,
  ) async {
    try {
      if (authToken.isEmpty) {
        return Result.error(Exception("Auth token is required"));
      }

      if (noteId.isEmpty) {
        return Result.error(Exception("Note ID is required"));
      }

      final noteUrl = '$_baseUrl/note/$noteId';

      final response = await _client.patch(
        Uri.parse(noteUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(noteData),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData is Map<String, dynamic>) {
          return Result.ok(responseData);
        } else {
          return const Result.error(HttpException("Invalid response format"));
        }
      } else if (response.statusCode == 404) {
        return Result.error(HttpException("Note not found: $noteId"));
      } else {
        return Result.error(
          HttpException("Update note failed: ${response.statusCode}"),
        );
      }
    } catch (error) {
      return Result.error(Exception('Update note failed: $error'));
    }
  }

  Future<Result<String>> deleteNote(String noteId, String authToken) async {
    try {
      if (authToken.isEmpty) {
        return Result.error(Exception("Auth token is required"));
      }

      if (noteId.isEmpty) {
        return Result.error(Exception("Note ID is required"));
      }

      final noteUrl = '$_baseUrl/note/$noteId';

      final response = await _client.delete(
        Uri.parse(noteUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        return Result.ok("Success!");
      } else if (response.statusCode == 404) {
        return Result.error(HttpException("Note not found: $noteId"));
      } else {
        return Result.error(
          HttpException("Delete note failed: ${response.statusCode}"),
        );
      }
    } catch (error) {
      return Result.error(Exception('Delete note failed: $error'));
    }
  }
}
