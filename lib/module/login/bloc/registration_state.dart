import 'package:equatable/equatable.dart';

abstract class RegistrationState extends Equatable {
  const RegistrationState();

  @override
  List<Object?> get props => [];
}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationSuccess extends RegistrationState {}

class RegistrationFailure extends RegistrationState {

  const RegistrationFailure(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
class RegistrationValidationError extends RegistrationState {

  const RegistrationValidationError({
    this.emailError,
    this.passwordError,
    this.nameError,
  });
  final String? emailError;
  final String? passwordError;
  final String? nameError;

  @override
  List<Object?> get props => [emailError, passwordError, nameError];
}

