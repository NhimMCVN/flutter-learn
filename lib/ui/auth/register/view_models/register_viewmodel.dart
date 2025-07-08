import 'package:first_flutter_app/data/repositories/auth/auth_repository.dart';
import 'package:first_flutter_app/utils/command.dart';
import 'package:first_flutter_app/utils/result.dart';
import 'package:logging/logging.dart';

class RegisterViewModel {
  final AuthRepository _authRepository;
  final _log = Logger("RegisterViewModel");
  late Command1 register;

  RegisterViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository {
    register = Command1<void, (String name, String email, String password)>(
      _register,
    );
  }

  Future<Result<void>> _register((String, String, String) credentials) async {
    final (name, email, password) = credentials;
    final result = await _authRepository.register(
      name: name,
      email: email,
      password: password,
    );
    if (result is Error<void>) {
      _log.warning('Register fail! ${result.error}');
    }
    return result;
  }
}
