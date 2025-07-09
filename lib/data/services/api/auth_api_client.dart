// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:first_flutter_app/data/services/api/models/login.dart';
import 'package:first_flutter_app/utils/result.dart';
import 'package:http/http.dart' as http;

class AuthApiClient {
  AuthApiClient({String? host, http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;

  Future<Result<LoginResponse>> login(LoginRequest loginRequest) async {
    try {
      final loginUrl =
          'https://x8ki-letl-twmt.n7.xano.io/api:qlhlF8OV/auth/login';

      final requestBody = {
        'email': loginRequest.email,
        'password': loginRequest.password,
      };

      final response = await _client.post(
        Uri.parse(loginUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
        final authToken = responseJson['authToken'] as String?;

        if (authToken != null) {
          return Result.ok(LoginResponse(authToken: authToken));
        } else {
          return const Result.error(HttpException("Missing auth token"));
        }
      } else {
        return Result.error(
          HttpException("Login failed: ${response.statusCode}"),
        );
      }
    } catch (error) {
      return Result.error(Exception('Login failed: $error'));
    }
  }

  Future<Result<LoginResponse>> register(
    RegisterRequest registerRequest,
  ) async {
    try {
      final registerUrl =
          'https://x8ki-letl-twmt.n7.xano.io/api:qlhlF8OV/auth/signup';

      final requestBody = {
        'email': registerRequest.email,
        'password': registerRequest.password,
        'name': registerRequest.name,
      };

      final response = await _client.post(
        Uri.parse(registerUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
        final authToken = responseJson['authToken'] as String?;

        if (authToken != null) {
          return Result.ok(LoginResponse(authToken: authToken));
        } else {
          return const Result.error(HttpException("Missing auth token"));
        }
      } else {
        return Result.error(
          HttpException("Register failed: ${response.statusCode}"),
        );
      }
    } catch (error) {
      return Result.error(Exception('Register failed: $error'));
    }
  }
}
