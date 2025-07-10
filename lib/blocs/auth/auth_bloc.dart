import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:first_flutter_app/data/repositories/auth/auth_repository.dart';
import 'package:first_flutter_app/data/services/shared_preferences_service.dart';
import 'package:first_flutter_app/blocs/auth/auth_event.dart';
import 'package:first_flutter_app/blocs/auth/auth_state.dart';
import 'package:first_flutter_app/utils/result.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final SharedPreferencesService _sharedPreferencesService;

  AuthBloc({
    required AuthRepository authRepository,
    required SharedPreferencesService sharedPreferencesService,
  }) : _authRepository = authRepository,
       _sharedPreferencesService = sharedPreferencesService,
       super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onCheckRequested);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final result = await _authRepository.login(
        email: event.email,
        password: event.password,
      );

      if (result is Ok<void>) {
        final tokenResult = await _sharedPreferencesService.fetchToken();
        if (tokenResult is Ok<String?> && tokenResult.value != null) {
          emit(AuthAuthenticated(tokenResult.value!));
        } else {
          emit(AuthError('Login successful but token not found.'));
        }
      } else if (result is Error) {
        emit(AuthError('Login failed. Please try again.'));
      }
    } catch (e) {
      emit(AuthError('An unexpected error occurred.'));
    }
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final result = await _authRepository.register(
        name: event.name,
        email: event.email,
        password: event.password,
      );

      if (result is Ok<void>) {
        final tokenResult = await _sharedPreferencesService.fetchToken();
        if (tokenResult is Ok<String?> && tokenResult.value != null) {
          emit(AuthAuthenticated(tokenResult.value!));
        } else {
          emit(AuthError('Registration successful but token not found.'));
        }
      } else if (result is Error) {
        emit(AuthError('Registration failed. Please try again.'));
      }
    } catch (e) {
      emit(AuthError('An unexpected error occurred.'));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.logout();
    emit(AuthUnauthenticated());
  }

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final result = await _sharedPreferencesService.fetchToken();

      if (result is Ok<String?> && result.value != null) {
        emit(AuthAuthenticated(result.value!));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }
}
