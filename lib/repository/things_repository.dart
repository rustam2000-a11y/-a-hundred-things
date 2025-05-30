import 'dart:io';

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
  Future<List<String>> uploadImages(List<File> images) async {
    return _baseDataApi.uploadImages(images);
  }
  @override
  Future<void> deleteItemByUid(String uid) async {
    return _baseDataApi.deleteItemByUid(uid);
  }
  @override
  Stream<List<ThingsModel>> searchThingsByTitle(String searchQuery) {
    final searchStreamController = BehaviorSubject<String>();
    searchStreamController.add(searchQuery);


    return searchStreamController.switchMap(
          (query) => _baseDataApi.searchThingsByTitle(query),
    );
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

  Stream<List<ThingsModel>> searchThingsByTitle(String searchQuery);

  Future<List<String>> uploadImages(List<File> images);
}
