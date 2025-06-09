part of 'create_new_thing_bloc.dart';

class CreateNewThingState extends Equatable {
  const CreateNewThingState({
    this.file,
  });

  final File? file;

  @override
  List<Object?> get props => [file];

  CreateNewThingState copyWith({
    File? file,
  }) {
    return CreateNewThingState(
      file: file ?? this.file,
    );
  }
}
