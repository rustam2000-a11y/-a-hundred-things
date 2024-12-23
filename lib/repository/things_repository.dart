import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import '../model/base_card_model.dart';
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

  @disposeMethod
  @override
  void dispose() {
    appStateStream?.close();
  }
}

abstract class ThingsRepositoryI {
  void dispose();

  Stream<List<ThingsModel>> fetchMyThings();
}
