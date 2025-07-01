import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginWithEmailEvent extends LoginEvent {
  final String email;
  final String password;

  const LoginWithEmailEvent(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class LoginWithGoogleEvent extends LoginEvent {
  const LoginWithGoogleEvent();

  @override
  List<Object?> get props => [];
}

class LoginWithAppleEvent extends LoginEvent {
  const LoginWithAppleEvent();

  @override
  List<Object?> get props => [];
}
