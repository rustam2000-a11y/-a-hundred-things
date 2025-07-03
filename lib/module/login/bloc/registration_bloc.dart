import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../repository/auth_repository.dart';
import 'registration_event.dart';
import 'registration_state.dart';

@injectable
class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final AuthRepositoryI _authRepository;
  bool _isHandlingRegistration = false;

  RegistrationBloc(this._authRepository) : super(RegistrationInitial()) {
    on<RegisterWithEmailEvent>(_onRegisterWithEmail);
    on<RegisterWithGoogleEvent>(_onRegisterWithGoogle);
    on<RegisterWithAppleEvent>(_onRegisterWithApple);
  }

  Future<void> _onRegisterWithEmail(
      RegisterWithEmailEvent event,
      Emitter<RegistrationState> emit,
      ) async {
    if (_isHandlingRegistration) return;
    _isHandlingRegistration = true;

    emit(RegistrationLoading());
    try {
      final user = await _authRepository.register(event.email, event.password);
      if (user != null) {
        await _authRepository.saveUserData(user, {
          'email': event.email,
          'name': event.name,
          'password': event.password,
        });
        emit(RegistrationSuccess());
      } else {
        emit(const RegistrationFailure('User is null'));
      }
    } catch (e) {
      emit(RegistrationFailure(e.toString()));
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

    emit(RegistrationLoading());
    try {
      final user = await _authRepository.loginWithGoogle();
      if (user != null) {
        await _authRepository.saveUserData(user, {
          'email': user.email ?? '',
          'name': user.displayName ?? '',
          'password': '',
        });
        emit(RegistrationSuccess());
      } else {
        emit(const RegistrationFailure('Google Sign-In failed'));
      }
    } catch (e) {
      emit(RegistrationFailure(e.toString()));
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

    emit(RegistrationLoading());
    try {
      final user = await _authRepository.loginWithApple();
      if (user != null) {
        await _authRepository.saveUserData(user, {
          'email': user.email ?? '',
          'name': user.displayName ?? '',
          'password': '',
        });
        emit(RegistrationSuccess());
      } else {
        emit(const RegistrationFailure('Apple Sign-In failed'));
      }
    } catch (e) {
      emit(RegistrationFailure(e.toString()));
    } finally {
      _isHandlingRegistration = false;
    }
  }
}
