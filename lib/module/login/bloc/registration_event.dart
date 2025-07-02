import 'package:equatable/equatable.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object?> get props => [];
}

class RegisterWithEmailEvent extends RegistrationEvent {

  const RegisterWithEmailEvent(this.email, this.password, this.name);
  final String email;
  final String password;
  final String name;

  @override
  List<Object> get props => [email, password, name];
}

class RegisterWithGoogleEvent extends RegistrationEvent {}

class RegisterWithAppleEvent extends RegistrationEvent {}
