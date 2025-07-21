import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../repository/navigator_repository.dart';


part 'progress_bar_event.dart';
part 'progress_bar_state.dart';

@injectable
class ProgressBarBloc extends Bloc<ProgressBarEvent, ProgressBarState> {

  ProgressBarBloc(this._repository) : super(const ProgressBarState()) {
    on<LoadProgressBar>((event, emit) => _loadData());
    on<_UpdateMaxItems>((event, emit) {
      emit(state.copyWith(maxItems: event.maxItems));
    });
    on<_UpdateTotalQuantity>((event, emit) {
      emit(state.copyWith(totalQuantity: event.totalQuantity));
    });
  }
  final NavigatorRepositoryI _repository;

  StreamSubscription<int>? _maxItemsSub;
  StreamSubscription<int>? _totalQuantitySub;

  void _loadData() {
    _maxItemsSub?.cancel();
    _totalQuantitySub?.cancel();

    _maxItemsSub = _repository.getMaxItems().listen((max) {
      add(_UpdateMaxItems(maxItems: max));
    });

    _totalQuantitySub = _repository.getTotalQuantity().listen((qty) {
      add(_UpdateTotalQuantity(totalQuantity: qty));
    });
  }

  @override
  Future<void> close() {
    _maxItemsSub?.cancel();
    _totalQuantitySub?.cancel();
    return super.close();
  }
}
