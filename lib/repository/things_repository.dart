
import 'dart:io';

import 'package:injectable/injectable.dart';
import '../model/things_model.dart';
import '../network/base_data_api.dart';

@LazySingleton(as: ThingsRepositoryI)
class ThingsRepository implements ThingsRepositoryI {
  ThingsRepository({required BaseDataApiI baseDataApi}) : _baseDataApi = baseDataApi;

  final BaseDataApiI _baseDataApi;

  @override
  Stream<List<ThingsModel>> fetchMyThings() {
    return _baseDataApi.fetchAllThings();
  }

  @override
  Future<List<ThingsModel>> fetchMyThingsOnce() {
    return _baseDataApi.fetchAllThings().first;
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
    return _baseDataApi.searchThingsByTitle(searchQuery);
  }

  @override
  void dispose() {
    // No longer needed
  }
}

abstract class ThingsRepositoryI {
  void dispose();

  Stream<List<ThingsModel>> fetchMyThings();

  Future<List<ThingsModel>> fetchMyThingsOnce();

  Future<void> deleteThingsByType(String type);

  Future<void> deleteItemByUid(String uid);

  Stream<List<ThingsModel>> searchThingsByTitle(String searchQuery);

  Future<List<String>> uploadImages(List<File> images);
}