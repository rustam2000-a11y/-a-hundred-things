//service locator
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'service_locator.config.dart';

GetIt sl = GetIt.instance;

T getIts<T extends Object>() => sl.get<T>();

@InjectableInit(
  //generateForDir: ['../../generated'],
    initializerName: r'$initGetIt', // default
    preferRelativeImports: true, // default
    asExtension: false, // default
    usesNullSafety: true)
void configureDependencies() => $initGetIt(sl);