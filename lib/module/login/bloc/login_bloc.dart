import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/auth_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this.repository) : super(const LoginState()) {
    on<LoginWithEmailEvent>(_onLoginWithEmail);
    on<LoginWithGoogleEvent>(_onLoginWithGoogle);
    on<LoginWithAppleEvent>(_onLoginWithApple);
  }

  final AuthRepositoryI repository;
  bool _isHandlingLogin = false;

  Future<void> _onLoginWithEmail(
    LoginWithEmailEvent event,
    Emitter<LoginState> emit,
  ) async {
    if (_isHandlingLogin) return;

    final emailError = event.email.trim().isEmpty ? 'Email is required' : null;
    final passwordError =
        event.password.trim().isEmpty ? 'Password is required' : null;

    if (emailError != null || passwordError != null) {
      emit(state.copyWith(
        emailError: emailError,
        passwordError: passwordError,
        isLoading: false,
        isSuccess: false,
      ));
      return;
    }

    _isHandlingLogin = true;

    emit(state.copyWith(
      isLoading: true,
      isSuccess: false,
    ));

    try {
      final user = await repository.login(event.email, event.password);
      if (user != null) {
        emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Invalid email or password',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Login failed. Please try again.',
      ));
    } finally {
      _isHandlingLogin = false;
    }
  }

  Future<void> _onLoginWithGoogle(
    LoginWithGoogleEvent event,
    Emitter<LoginState> emit,
  ) async {
    if (_isHandlingLogin) return;
    _isHandlingLogin = true;

    emit(state.copyWith(
      isLoading: true,
      isSuccess: false,
    ));

    try {
      final user = await repository.loginWithGoogle();
      if (user != null) {
        emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Google login cancelled',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Google login error. Please try again.',
      ));
    } finally {
      _isHandlingLogin = false;
    }
  }

  Future<void> _onLoginWithApple(
    LoginWithAppleEvent event,
    Emitter<LoginState> emit,
  ) async {
    if (_isHandlingLogin) return;
    _isHandlingLogin = true;

    emit(state.copyWith(
      isLoading: true,
      isSuccess: false,
    ));

    try {
      final user = await repository.loginWithApple();
      if (user != null) {
        emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Apple login cancelled',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Apple login error. Please try again.',
      ));
    } finally {
      _isHandlingLogin = false;
    }
  }
}
