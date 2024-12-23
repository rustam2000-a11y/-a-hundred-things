import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../model/base_card_model.dart';
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
  }

  final ThingsRepositoryI _thingsRepository;
  StreamSubscription<dynamic>? thingsSub;

  void init() {
    thingsSub = _thingsRepository.fetchMyThings().listen((list) {
      add(HomeThingsEvent(things: list));
    });
  }

  @override
  Future<void> close() {
    thingsSub?.cancel();
    return super.close();
  }
}
