import 'package:first_flutter_app/data/services/api/models/login.dart';
import 'package:logging/logging.dart';

import '../../../utils/result.dart';
import '../../services/api/api_client.dart';
import '../../services/api/auth_api_client.dart';
import '../../services/shared_preferences_service.dart';
import 'auth_repository.dart';

class AuthRepositoryRemote extends AuthRepository {
  AuthRepositoryRemote({
    required AuthApiClient authApiClient,
    required SharedPreferencesService sharedPreferencesService,
  }) : _authApiClient = authApiClient,
       _sharedPreferencesService = sharedPreferencesService {}

  final AuthApiClient _authApiClient;
  final SharedPreferencesService _sharedPreferencesService;

  bool? _isAuthenticated;
  String? _authToken;
  final _log = Logger('AuthRepositoryRemote');

  Future<void> _fetch() async {
    final result = await _sharedPreferencesService.fetchToken();
    switch (result) {
      case Ok<String?>():
        _authToken = result.value;
        _isAuthenticated = result.value != null;
      case Error<String?>():
        _log.severe(
          'Failed to fech Token from SharedPreferences',
          result.error,
        );
    }
  }

  @override
  Future<bool> get isAuthenticated async {
    if (_isAuthenticated != null) {
      return _isAuthenticated!;
    }
    await _fetch();
    return _isAuthenticated ?? false;
  }

  @override
  Future<Result<void>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _authApiClient.login(
        LoginRequest(email: email, password: password),
      );
      switch (result) {
        case Ok<LoginResponse>():
          _log.info('User logged int');
          _isAuthenticated = true;
          _authToken = result.value.authToken;
          return await _sharedPreferencesService.saveToken(
            result.value.authToken,
          );
        case Error<LoginResponse>():
          _log.warning('Error logging in: ${result.error}');
          return Result.error(result.error);
      }
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<Result<void>> logout() async {
    _log.info('User logged out');
    try {
      final result = await _sharedPreferencesService.saveToken(null);
      if (result is Error<void>) {
        _log.severe('Failed to clear stored auth token');
      }
      _authToken = null;
      _isAuthenticated = false;
      return result;
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<Result<void>> register({
    required String email,
    required String name,
    required String password,
  }) {
    // TODO: implement register
    throw UnimplementedError();
  }

  String? _authHeaderProvider() =>
      _authToken != null ? 'Bearer $_authToken' : null;
}
