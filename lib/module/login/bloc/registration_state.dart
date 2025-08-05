import 'package:equatable/equatable.dart';

class RegistrationState extends Equatable {
  const RegistrationState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.emailError,
    this.passwordError,
    this.nameError,
  });

  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final String? emailError;
  final String? passwordError;
  final String? nameError;

  @override
  List<Object?> get props => [
        isLoading,
        isSuccess,
        errorMessage,
        emailError,
        passwordError,
        nameError,
      ];

  RegistrationState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    String? emailError,
    String? passwordError,
    String? nameError,
  }) {
    return RegistrationState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      emailError: emailError,
      passwordError: passwordError,
      nameError: nameError,
    );
  }
}
