import 'dart:io';
import 'package:injectable/injectable.dart';
import '../network/setting_data_api.dart';

abstract class SettingRepositoryI {
  Future<Map<String, dynamic>> getUserData();
  Future<String> uploadAvatar(File image);
  Future<void> saveUserData({
    required String name,
    required String email,
    required String phone,
    required String password,
  });
}

@LazySingleton(as: SettingRepositoryI)
class SettingRepository implements SettingRepositoryI {
  SettingRepository(this._api);
  final SettingDataApiI _api;

  @override
  Future<Map<String, dynamic>> getUserData() => _api.fetchUserProfile();

  @override
  Future<String> uploadAvatar(File image) => _api.uploadUserAvatar(image);

  @override
  Future<void> saveUserData({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) => _api.updateUserProfile(
    name: name,
    email: email,
    phone: phone,
    password: password,
  );
}
