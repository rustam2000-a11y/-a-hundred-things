part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class HomeInitEvent extends HomeEvent {
  const HomeInitEvent();

  @override
  List<Object?> get props => [];
}

class HomeProgressEvent extends HomeEvent {
  const HomeProgressEvent({required this.isProgress});

  final bool isProgress;

  @override
  List<Object?> get props => [isProgress];
}

class HomeThingsEvent extends HomeEvent {
  const HomeThingsEvent({required this.things});

  final List<ThingsModel> things;

  @override
  List<Object?> get props => [things];
}
