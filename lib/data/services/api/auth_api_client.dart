import 'dart:convert';
import 'dart:io';

import 'package:first_flutter_app/data/services/api/models/login.dart';
import 'package:first_flutter_app/utils/result.dart';
import 'package:first_flutter_app/config/environment.dart';
import 'package:http/http.dart' as http;

class AuthApiClient {
  final http.Client _client;
  final String _baseUrl;

  AuthApiClient({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      _baseUrl = baseUrl ?? Environment.authApiBaseUrl;

  Future<Result<LoginResponse>> login(LoginRequest loginRequest) async {
    return _makeAuthRequest(
      endpoint: Environment.authLoginEndpoint,
      body: {'email': loginRequest.email, 'password': loginRequest.password},
      errorMessage: 'Login failed',
    );
  }

  Future<Result<LoginResponse>> register(
    RegisterRequest registerRequest,
  ) async {
    return _makeAuthRequest(
      endpoint: Environment.authRegisterEndpoint,
      body: {
        'email': registerRequest.email,
        'password': registerRequest.password,
        'name': registerRequest.name,
      },
      errorMessage: 'Register failed',
    );
  }

  Future<Result<LoginResponse>> _makeAuthRequest({
    required String endpoint,
    required Map<String, String> body,
    required String errorMessage,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl$endpoint');

      final response = await _client.post(
        url,
        headers: _getHeaders(),
        body: jsonEncode(body),
      );

      return _handleResponse(response, errorMessage);
    } catch (error) {
      return Result.error(Exception('$errorMessage: $error'));
    }
  }

  Map<String, String> _getHeaders() {
    return {'Content-Type': 'application/json', 'Accept': 'application/json'};
  }

  Result<LoginResponse> _handleResponse(
    http.Response response,
    String errorMessage,
  ) {
    if (response.statusCode == 200) {
      try {
        final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
        final authToken = responseJson['authToken'] as String?;

        if (authToken != null) {
          return Result.ok(LoginResponse(authToken: authToken));
        } else {
          return const Result.error(HttpException("Missing auth token"));
        }
      } catch (e) {
        return Result.error(Exception("Failed to parse response: $e"));
      }
    } else {
      return Result.error(
        HttpException("$errorMessage: ${response.statusCode}"),
      );
    }
  }
}
