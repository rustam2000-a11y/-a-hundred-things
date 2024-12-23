// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../network/base_data_api.dart' as _i323;
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
  gh.lazySingleton<_i323.BaseDataApiI>(() => _i323.BaseDataApi());
  gh.lazySingleton<_i878.ThingsRepositoryI>(
    () => _i878.ThingsRepository(baseDataApi: gh<_i323.BaseDataApiI>()),
    dispose: (i) => i.dispose(),
  );
  return getIt;
}
