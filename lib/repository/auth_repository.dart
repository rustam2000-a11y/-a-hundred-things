import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../network/auth_data_api.dart';

abstract class AuthRepositoryI {
  Future<User?> login(String email, String password);
  Future<User?> register(String email, String password);
  Future<void> saveUserData(User user, Map<String, dynamic> data);
  Future<User?> loginWithGoogle();
  Future<User?> loginWithApple();
}

@LazySingleton(as: AuthRepositoryI)
class AuthRepository implements AuthRepositoryI {

  AuthRepository(this._api);
  final AuthDataApiI _api;

  @override
  Future<User?> login(String email, String password) {
    return _api.signInWithEmail(email, password);
  }

  @override
  Future<User?> register(String email, String password) {
    return _api.registerWithEmail(email, password);
  }

  @override
  Future<void> saveUserData(User user, Map<String, dynamic> data) {
    return _api.addUserData(user, data);
  }

  @override
  Future<User?> loginWithGoogle() => _api.signInWithGoogle();

  @override
  Future<User?> loginWithApple() => _api.signInWithApple();
}
