part of 'create_new_thing_bloc.dart';

class CreateNewThingState extends Equatable {
  const CreateNewThingState({
    this.files = const [],
    this.thing,
  });

  final List<File> files;
  final ThingsModel? thing;

  @override
  List<Object?> get props => [files, thing];

  CreateNewThingState copyWith({
    List<File>? files,
    ThingsModel? thing,
  }) {
    return CreateNewThingState(
      files: files ?? this.files,
      thing: thing ?? this.thing,
    );
  }
}



