import 'package:first_flutter_app/data/repositories/auth/auth_repository.dart';
import 'package:first_flutter_app/utils/command.dart';
import 'package:first_flutter_app/utils/result.dart';
import 'package:logging/logging.dart';

class LoginViewModel {
  final AuthRepository _authRepository;
  final _log = Logger("LoginViewModel");
  late Command1 login;

  LoginViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository {
    login = Command1<void, (String email, String password)>(_login);
  }

  Future<Result<void>> _login((String, String) credentials) async {
    final (email, password) = credentials;
    final result = await _authRepository.login(
      email: email,
      password: password,
    );
    if (result is Error<void>) {
      _log.warning('Login fail! ${result.error}');
    }
    return result;
  }
}
