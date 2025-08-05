import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../repository/auth_repository.dart';
import 'registration_event.dart';
import 'registration_state.dart';

@injectable
class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc(this._authRepository)
      : super(const RegistrationState()) {
    on<ValidateFieldsBeforeRegisterEvent>(_onValidateFieldsBeforeRegister);
    on<RegisterWithEmailEvent>(_onRegisterWithEmail);
    on<RegisterWithGoogleEvent>(_onRegisterWithGoogle);
    on<RegisterWithAppleEvent>(_onRegisterWithApple);
  }

  final AuthRepositoryI _authRepository;
  bool _isHandlingRegistration = false;

  void _onValidateFieldsBeforeRegister(
      ValidateFieldsBeforeRegisterEvent event,
      Emitter<RegistrationState> emit,
      ) {
    final emailError =
    event.email.trim().isEmpty ? 'Email is required' : null;
    final passwordError =
    event.password.trim().isEmpty ? 'Password is required' : null;
    final nameError =
    event.name.trim().isEmpty ? 'Name is required' : null;

    if (emailError != null || passwordError != null || nameError != null) {
      emit(state.copyWith(
        emailError: emailError,
        passwordError: passwordError,
        nameError: nameError,
        isLoading: false,
        isSuccess: false,
      ));
      return;
    }

    add(RegisterWithEmailEvent(
      event.email.trim(),
      event.password.trim(),
      event.name.trim(),
    ));
  }

  Future<void> _onRegisterWithEmail(
      RegisterWithEmailEvent event,
      Emitter<RegistrationState> emit,
      ) async {
    if (_isHandlingRegistration) return;
    _isHandlingRegistration = true;

    emit(state.copyWith(
      isLoading: true,
      isSuccess: false,
    ));

    try {
      final user = await _authRepository.register(event.email, event.password);
      if (user != null) {
        await _authRepository.saveUserData(user, {
          'email': event.email,
          'name': event.name,
          'password': event.password,
        });
        emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'User is null',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    } finally {
      _isHandlingRegistration = false;
    }
  }

  Future<void> _onRegisterWithGoogle(
      RegisterWithGoogleEvent event,
      Emitter<RegistrationState> emit,
      ) async {
    if (_isHandlingRegistration) return;
    _isHandlingRegistration = true;

    emit(state.copyWith(
      isLoading: true,
      isSuccess: false,
    ));

    try {
      final user = await _authRepository.loginWithGoogle();
      if (user != null) {
        await _authRepository.saveUserData(user, {
          'email': user.email ?? '',
          'name': user.displayName ?? '',
          'password': '',
        });
        emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Google Sign-In failed',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    } finally {
      _isHandlingRegistration = false;
    }
  }

  Future<void> _onRegisterWithApple(
      RegisterWithAppleEvent event,
      Emitter<RegistrationState> emit,
      ) async {
    if (_isHandlingRegistration) return;
    _isHandlingRegistration = true;

    emit(state.copyWith(
      isLoading: true,
      isSuccess: false,

    ));

    try {
      final user = await _authRepository.loginWithApple();
      if (user != null) {
        await _authRepository.saveUserData(user, {
          'email': user.email ?? '',
          'name': user.displayName ?? '',
          'password': '',
        });
        emit(state.copyWith(
          isLoading: false,
          isSuccess: true,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Apple Sign-In failed',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    } finally {
      _isHandlingRegistration = false;
    }
  }
}
