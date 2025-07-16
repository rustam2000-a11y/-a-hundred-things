part of 'account_bloc.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object?> get props => [];
}

class LoadAccountData extends AccountEvent {}

class UpdateAccountData extends AccountEvent {

  const UpdateAccountData({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });
  final String name;
  final String email;
  final String phone;
  final String password;

  @override
  List<Object?> get props => [name, email, phone, password];

}
class UpdateAvatarEvent extends AccountEvent {

  const UpdateAvatarEvent(this.avatarPath);
  final String avatarPath;

  @override
  List<Object?> get props => [avatarPath];
}
