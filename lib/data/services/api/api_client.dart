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
}
