part of 'create_new_thing_bloc.dart';

class CreateNewThingState extends Equatable {
  const CreateNewThingState({
    this.file,
    this.thing,
  });

  final File? file;
  final ThingsModel? thing;

  @override
  List<Object?> get props => [file, thing];

  CreateNewThingState copyWith({
    File? file,
    ThingsModel? thing,
  }) {
    return CreateNewThingState(
      file: file ?? this.file,
      thing: thing ?? this.thing,
    );
  }
}


