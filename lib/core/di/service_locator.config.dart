// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../module/home/home_bloc.dart' as _i17;
import '../../module/login/bloc/registration_bloc.dart' as _i501;
import '../../module/settings/bloc/account_bloc.dart' as _i952;
import '../../module/things/new_things/create_new_thing_bloc.dart' as _i1045;
import '../../module/things/new_things/image_picker_servirs.dart' as _i53;
import '../../network/auth_data_api.dart' as _i380;
import '../../network/base_data_api.dart' as _i323;
import '../../network/setting_data_api.dart' as _i93;
import '../../repository/auth_repository.dart' as _i242;
import '../../repository/setting_repository.dart' as _i169;
import '../../repository/things_repository.dart' as _i878;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.lazySingleton<_i53.ImagePickerService>(() => _i53.ImagePickerService());
  gh.lazySingleton<_i380.AuthDataApiI>(() => _i380.AuthDataApi());
  gh.lazySingleton<_i323.BaseDataApiI>(() => _i323.BaseDataApi());
  gh.factory<_i1045.CreateNewThingBloc>(
      () => _i1045.CreateNewThingBloc(gh<_i53.ImagePickerService>()));
  gh.lazySingleton<_i93.SettingDataApiI>(() => _i93.SettingDataApi());
  gh.lazySingleton<_i878.ThingsRepositoryI>(
      () => _i878.ThingsRepository(baseDataApi: gh<_i323.BaseDataApiI>()));
  gh.factory<_i17.HomeBloc>(
      () => _i17.HomeBloc(thingsRepository: gh<_i878.ThingsRepositoryI>()));
  gh.lazySingleton<_i242.AuthRepositoryI>(
      () => _i242.AuthRepository(gh<_i380.AuthDataApiI>()));
  gh.lazySingleton<_i169.SettingRepositoryI>(
      () => _i169.SettingRepository(gh<_i93.SettingDataApiI>()));
  gh.factory<_i952.AccountBloc>(
      () => _i952.AccountBloc(gh<_i169.SettingRepositoryI>()));
  gh.factory<_i501.RegistrationBloc>(
      () => _i501.RegistrationBloc(gh<_i242.AuthRepositoryI>()));
  return getIt;
}
