import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../repository/auth_repository.dart';
import 'login_event.dart';
import 'login_state.dart';


class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepositoryI repository;

  LoginBloc(this.repository) : super(const LoginInitial()) {
    on<LoginWithEmailEvent>(_onLoginWithEmail);
    on<LoginWithGoogleEvent>(_onLoginWithGoogle);
    on<LoginWithAppleEvent>(_onLoginWithApple);
  }

  Future<void> _onLoginWithEmail(LoginWithEmailEvent event, Emitter<LoginState> emit) async {
    emit(const LoginLoading());
    try {
      final user = await repository.login(event.email, event.password);
      if (user != null) {
        emit(const LoginSuccess());
      } else {
        emit(const LoginFailure('Invalid email or password'));
      }
    } catch (e) {
      emit(LoginFailure('Login failed: $e'));
    }
  }

  Future<void> _onLoginWithGoogle(LoginWithGoogleEvent event, Emitter<LoginState> emit) async {
    emit(const LoginLoading());
    try {
      final user = await repository.loginWithGoogle();
      if (user != null) {
        emit(const LoginSuccess());
      } else {
        emit(const LoginFailure('Google login cancelled'));
      }
    } catch (e) {
      emit(LoginFailure('Google login error: $e'));
    }
  }

  Future<void> _onLoginWithApple(LoginWithAppleEvent event, Emitter<LoginState> emit) async {
    emit(const LoginLoading());
    try {
      final user = await repository.loginWithApple();
      if (user != null) {
        emit(const LoginSuccess());
      } else {
        emit(const LoginFailure('Apple login cancelled'));
      }
    } catch (e) {
      emit(LoginFailure('Apple login error: $e'));
    }
  }
}
