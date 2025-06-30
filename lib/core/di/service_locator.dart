import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
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
    sl.registerLazySingleton<SettingDataApiI>(() => SettingDataApi());
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
}
