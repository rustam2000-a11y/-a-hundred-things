import 'package:injectable/injectable.dart';

import '../network/navigator_api.dart';


@LazySingleton(as: NavigatorRepositoryI)
class NavigatorRepository implements NavigatorRepositoryI {

  NavigatorRepository(this._api);
  final NavigatorDataApiI _api;

  @override
  Stream<int> getMaxItems() => _api.fetchMaxItems();

  @override
  Stream<int> getTotalQuantity() => _api.fetchTotalQuantity();
}
abstract class NavigatorRepositoryI {
  Stream<int> getMaxItems();
  Stream<int> getTotalQuantity();
}