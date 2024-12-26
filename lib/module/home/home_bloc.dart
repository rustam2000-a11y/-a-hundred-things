import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../model/things_model.dart';
import '../../repository/things_repository.dart';

part 'home_event.dart';

part 'home_state.dart';

@Injectable()
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required ThingsRepositoryI thingsRepository,
  })  : _thingsRepository = thingsRepository,
        super(const HomeState()) {
    on<HomeInitEvent>((event, emit) {
      init();
    });
    on<HomeProgressEvent>((event, emit) {
      emit(state.copyWith(isProgress: event.isProgress));
    });
    on<HomeThingsEvent>((event, emit) {
      emit(state.copyWith(things: event.things));
    });
    on<HomeTypeThingsEvent>((event, emit) {
      emit(state.copyWith(typesWithColors: event.typesWithColors));
    });
    on<HomeSelectTypeThingsEvent>((event, emit) {
      changeTypeThings(event.selectedTypeThings);
    });
    on<DeleteThingsByTypeEvent>((event, emit) {
      deleteThingsByType(event.type);
    });
    on<DeleteItemByUidEvent>((event, emit) {
      deleteItemByUid(event.uid);
    });
  }

  final ThingsRepositoryI _thingsRepository;
  StreamSubscription<dynamic>? thingsSub;
  StreamSubscription<dynamic>? categorySub;

  void init() {
    thingsSub = _thingsRepository.fetchMyThings().listen((list) {
      add(HomeThingsEvent(things: list));

      final typesWithColors = list.fold<Map<String, String>>({}, (map, item) {
        final type = item.type;
        final color = item.color;
        map[type] = color;
        return map;
      });

      add(HomeTypeThingsEvent(typesWithColors: typesWithColors));
    });
  }

  void changeTypeThings(String? selectedType) {
    categorySub = _thingsRepository.fetchMyThings().listen((list) {
      final filteredList = selectedType != null
          ? list.where((element) => element.type == selectedType).toList()
          : list;
      add(HomeThingsEvent(things: filteredList));
    });
  }

  Future<void> deleteThingsByType(String type) async {
    await _thingsRepository.deleteThingsByType(type);
  }

  Future<void> deleteItemByUid(String uid) async {
    await _thingsRepository.deleteItemByUid(uid);
  }

  @override
  Future<void> close() {
    thingsSub?.cancel();
    categorySub?.cancel();
    return super.close();
  }
}
