// Updated HomeBloc (home_bloc.dart)
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../model/things_model.dart';
import '../../../../repository/things_repository.dart';

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
      filterThingsByField(event.field, event.value);
    });
    on<DeleteThingsByTypeEvent>((event, emit) {
      deleteThingsByType(event.type);
    });
    on<DeleteItemByUidEvent>((event, emit) {
      deleteItemByUid(event.uid);
    });
    on<DeleteItemsByUidsEvent>(_onDeleteItemsByUids);

  }

  final ThingsRepositoryI _thingsRepository;
  StreamSubscription<dynamic>? thingsSub;
  StreamSubscription<dynamic>? categorySub;

  void init() {
    thingsSub?.cancel();
    thingsSub = _thingsRepository.fetchMyThings().listen((list) {
      add(HomeThingsEvent(things: List.from(list)));

      final typesWithColors = <String, String>{};

      for (final item in list) {
        final color = item.color;
        for (final type in item.type) {
          typesWithColors[type] = color;
        }
      }

      add(HomeTypeThingsEvent(typesWithColors: typesWithColors));
    });
  }

  void filterThingsByField(String field, String value) {
    categorySub?.cancel();

    if (value.trim().isEmpty) {
      init();
      return;
    }

    categorySub = _thingsRepository.fetchMyThings().listen((list) {
      final filteredList = list.where((element) {
        final map = element.toJson();
        final fieldValue = map[field];

        if (fieldValue == null) return false;

        final normalizedTargetValue = value.trim().toLowerCase();

        if (field == 'type' && fieldValue is List) {
          return fieldValue
              .map((t) => t.toString().trim().toLowerCase())
              .contains(normalizedTargetValue);
        } else {
          final normalizedFieldValue =
              fieldValue.toString().trim().toLowerCase();
          return normalizedFieldValue == normalizedTargetValue;
        }
      }).toList();

      add(HomeThingsEvent(things: filteredList));
    });
  }

  Future<void> deleteThingsByType(String type) async {
    await _thingsRepository.deleteThingsByType(type);
  }

  Future<void> deleteItemByUid(String uid) async {
    await _thingsRepository.deleteItemByUid(uid);
  }

  Future<void> forceReload() async {
    final list = await _thingsRepository.fetchMyThingsOnce();

    final updatedList = list.map((e) => e.copyWith()).toList();

    add(HomeThingsEvent(things: updatedList));

    final typesWithColors = <String, String>{};
    for (final item in updatedList) {
      for (final type in item.type) {
        typesWithColors[type] = item.color;
      }
    }

    add(HomeTypeThingsEvent(typesWithColors: typesWithColors));
  }
  Future<void> _onDeleteItemsByUids(
      DeleteItemsByUidsEvent event,
      Emitter<HomeState> emit,
      ) async {
    emit(state.copyWith(isProgress: true));

    try {
      await _thingsRepository.deleteItemsByUids(event.uids);

      final updatedList = await _thingsRepository.fetchMyThingsOnce();
      add(HomeThingsEvent(things: updatedList));

      final typesWithColors = <String, String>{};
      for (final item in updatedList) {
        for (final type in item.type) {
          typesWithColors[type] = item.color;
        }
      }
      add(HomeTypeThingsEvent(typesWithColors: typesWithColors));
    } catch (e) {
    }

    emit(state.copyWith(isProgress: false));
  }

  @override
  Future<void> close() {
    thingsSub?.cancel();
    categorySub?.cancel();
    return super.close();
  }
}
