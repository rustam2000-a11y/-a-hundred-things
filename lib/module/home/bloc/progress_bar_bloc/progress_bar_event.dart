part of 'progress_bar_bloc.dart';

abstract class ProgressBarEvent extends Equatable {
  const ProgressBarEvent();

  @override
  List<Object?> get props => [];
}

class LoadProgressBar extends ProgressBarEvent {}

class _UpdateMaxItems extends ProgressBarEvent {
  const _UpdateMaxItems({required this.maxItems});

  final int maxItems;

  @override
  List<Object> get props => [maxItems];
}

class _UpdateTotalQuantity extends ProgressBarEvent {
  const _UpdateTotalQuantity({required this.totalQuantity});

  final int totalQuantity;

  @override
  List<Object> get props => [totalQuantity];
}
