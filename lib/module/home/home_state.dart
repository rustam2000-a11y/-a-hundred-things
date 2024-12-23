part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState({
    this.isProgress = false,
    this.things = const [],
  });

  final bool isProgress;
  final List<ThingsModel> things;

  @override
  List<Object> get props => [isProgress, things];

  HomeState copyWith({
    bool? isProgress,
    List<ThingsModel>? things,
  }) {
    return HomeState(
      isProgress: isProgress ?? this.isProgress,
      things: things ?? this.things,
    );
  }
}
