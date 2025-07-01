import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import '../../module/login/bloc/login_bloc.dart';
import '../../network/auth_data_api.dart';
import '../../repository/auth_repository.dart';
import 'service_locator.config.dart';

import 'package:one_hundred_things/repository/setting_repository.dart';
import 'package:one_hundred_things/network/setting_data_api.dart';
import 'package:one_hundred_things/module/settings/bloc/account_bloc.dart';

final sl = GetIt.instance;

T getIts<T extends Object>() => sl.get<T>();

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: false,
  usesNullSafety: true,
)
void configureDependencies() {
  $initGetIt(sl);

  if (!sl.isRegistered<SettingDataApiI>()) {
    sl.registerLazySingleton<SettingDataApiI>(SettingDataApi.new);
  }

  if (!sl.isRegistered<SettingRepositoryI>()) {
    sl.registerLazySingleton<SettingRepositoryI>(
          () => SettingRepository(sl<SettingDataApiI>()),
    );
  }

  if (!sl.isRegistered<AccountBloc>()) {
    sl.registerFactory<AccountBloc>(
          () => AccountBloc(sl<SettingRepositoryI>()),
    );
  }
  if (!sl.isRegistered<AuthDataApiI>()) {
    sl.registerLazySingleton<AuthDataApiI>(AuthDataApi.new);
  }

  if (!sl.isRegistered<AuthRepositoryI>()) {
    sl.registerLazySingleton<AuthRepositoryI>(
          () => AuthRepository(sl<AuthDataApiI>()),
    );
  }

  if (!sl.isRegistered<LoginBloc>()) {
    sl.registerFactory<LoginBloc>(
          () => LoginBloc(sl<AuthRepositoryI>()),
    );
  }

}
