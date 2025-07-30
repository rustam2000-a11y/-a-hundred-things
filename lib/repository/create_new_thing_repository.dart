import 'package:injectable/injectable.dart';
import '../model/things_model.dart';
import '../network/create_thing_api.dart';

abstract class CreateThingRepositoryI {
  Future<void> addThing(ThingsModel model);

  Future<void> updateThing(ThingsModel model);

  Future<ThingsModel?> fetchThing(String id);

  Future<void> updateFavorite(String id, bool isFavorite);

  Future<void> addType(Map<String, dynamic> typeData);

  Future<void> updateType(String id, Map<String, dynamic> typeData);

  Future<Map<String, dynamic>?> fetchType(String id);
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

  @override
  Future<void> addType(Map<String, dynamic> typeData) => _api.addType(typeData);

  @override
  Future<void> updateType(String id, Map<String, dynamic> typeData) =>
      _api.updateType(id, typeData);

  @override
  Future<Map<String, dynamic>?> fetchType(String id) => _api.fetchType(id);
}
