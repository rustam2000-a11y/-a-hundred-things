import 'package:injectable/injectable.dart';
import '../model/things_model.dart';
import '../network/create_thing_api.dart';

abstract class CreateThingRepositoryI {
  Future<void> addThing(ThingsModel model);

  Future<void> updateThing(ThingsModel model);

  Future<ThingsModel?> fetchThing(String id);

  Future<void> updateFavorite(String id, bool isFavorite);
}

@LazySingleton(as: CreateThingRepositoryI)
class CreateThingRepository implements CreateThingRepositoryI {
  CreateThingRepository(this._api);

  final CreateThingApiI _api;

  @override
  Future<void> addThing(ThingsModel model) => _api.addThing(model);

  @override
  Future<void> updateThing(ThingsModel model) => _api.updateThing(model);

  @override
  Future<ThingsModel?> fetchThing(String id) => _api.fetchThing(id);

  @override
  Future<void> updateFavorite(String id, bool isFavorite) =>
      _api.updateFavorite(id, isFavorite);
}
