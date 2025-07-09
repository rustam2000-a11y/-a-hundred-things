part of 'account_bloc.dart';

class AccountState extends Equatable {

  const AccountState({
    this.name = '',
    this.email = '',
    this.phone = '',
    this.password = '',
    this.avatarUrl = '',
    this.isLoading = false,
    this.isAvatarUploading = false,
    this.error,
  });
  final String name;
  final String email;
  final String phone;
  final String password;
  final String avatarUrl;
  final bool isLoading;
  final String? error;
  final bool isAvatarUploading;

  AccountState copyWith({
    String? name,
    String? email,
    String? phone,
    String? password,
    String? avatarUrl,
    bool? isLoading,
    String? error,
    bool? isAvatarUploading,
  }) {
    return AccountState(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAvatarUploading: isAvatarUploading ?? this.isAvatarUploading,
    );
  }

  @override
  List<Object?> get props => [name, email, phone, password, avatarUrl, isLoading, error,isAvatarUploading,];
}
