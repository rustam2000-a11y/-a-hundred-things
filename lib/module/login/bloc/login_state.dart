import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  const LoginState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.emailError,
    this.passwordError,
  });

  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final String? emailError;
  final String? passwordError;

  @override
  List<Object?> get props => [
    isLoading,
    isSuccess,
    errorMessage,
    emailError,
    passwordError,
  ];

  LoginState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    String? emailError,
    String? passwordError,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      emailError: emailError,
      passwordError: passwordError,
    );
  }
}
