import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import '../model/things_model.dart';
import '../network/base_data_api.dart';

@LazySingleton(as: ThingsRepositoryI)
class ThingsRepository implements ThingsRepositoryI {
  ThingsRepository({required BaseDataApiI baseDataApi})
      : _baseDataApi = baseDataApi;
  final BaseDataApiI _baseDataApi;

  BehaviorSubject<List<ThingsModel>>? appStateStream =
      BehaviorSubject<List<ThingsModel>>();

  @override
  Stream<List<ThingsModel>> fetchMyThings() {
    _baseDataApi.fetchAllThings().listen((things) {
      appStateStream!.sink.add(things);
    });
    return appStateStream!;
  }

  @override
  Future<void> deleteThingsByType(String type) async {
    return _baseDataApi.deleteThingsByType(type);
  }

  @override
  Future<void> deleteItemByUid(String uid) async {
    return _baseDataApi.deleteItemByUid(uid);
  }

  @disposeMethod
  @override
  void dispose() {
    appStateStream?.close();
  }
}

abstract class ThingsRepositoryI {
  void dispose();

  Stream<List<ThingsModel>> fetchMyThings();

  Future<void> deleteThingsByType(String type);

  Future<void> deleteItemByUid(String uid);
}
