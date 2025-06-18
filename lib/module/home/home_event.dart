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

class HomeTypeThingsEvent extends HomeEvent {
  const HomeTypeThingsEvent({


    required this.typesWithColors,
  });


  final Map<String, String> typesWithColors;

  @override
  List<Object?> get props => [
        typesWithColors

      ];
}

class HomeSelectTypeThingsEvent extends HomeEvent {
  const HomeSelectTypeThingsEvent({
    required this.field,
    required this.value,
  });

  final String field;
  final String value;

  @override
  List<Object?> get props => [field, value];
}


class DeleteThingsByTypeEvent extends HomeEvent {
  const DeleteThingsByTypeEvent({required this.type});

  final String type;

  @override
  List<Object?> get props => [type];
}

class DeleteItemByUidEvent extends HomeEvent {
  const DeleteItemByUidEvent({required this.uid});

  final String uid;

  @override
  List<Object?> get props => [uid];
}
