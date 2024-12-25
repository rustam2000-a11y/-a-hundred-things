part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState({
    this.isProgress= false,
    this.things = const [],
    this.typeThings = const [],
    this.typesWithColors = const {},
  });

  final bool isProgress;
  final List<ThingsModel> things;
  final List<ThingsModel> typeThings;
  final Map<String, String> typesWithColors;

  @override
  List<Object?> get props => [
        isProgress,
        things,
        typeThings,
        typesWithColors,
      ];

  HomeState copyWith({
    bool? isProgress,
    List<ThingsModel>? things,
    List<ThingsModel>? typeThings,
    Map<String, String>? typesWithColors,
  }) {
    return HomeState(
      isProgress: isProgress ?? this.isProgress,
      things: things ?? this.things,
      typeThings: typeThings ?? this.typeThings,
      typesWithColors: typesWithColors ?? this.typesWithColors,
    );
  }
}
