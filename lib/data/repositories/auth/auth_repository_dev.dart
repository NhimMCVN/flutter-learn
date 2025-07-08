import '../../../utils/result.dart';
import 'auth_repository.dart';

class AuthRepositoryDev extends AuthRepository {
  @override
  Future<bool> get isAuthenticated => Future.value(false);

  @override
  Future<Result<void>> login({
    required String email,
    required String password,
  }) async {
    return const Result.ok(null);
  }

  @override
  Future<Result<void>> logout() async {
    return const Result.ok(null);
  }

  @override
  Future<Result<void>> register({
    required String name,
    required String email,
    required dynamic password,
  }) async {
    return const Result.ok(null);
  }
}
