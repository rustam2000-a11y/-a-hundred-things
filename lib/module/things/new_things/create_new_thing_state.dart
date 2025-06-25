part of 'create_new_thing_bloc.dart';

class CreateNewThingState extends Equatable {
  const CreateNewThingState({
    this.file,
    this.detectedLabel,
  });

  final File? file;
  final String? detectedLabel;

  @override
  List<Object?> get props => [file, detectedLabel];

  CreateNewThingState copyWith({
    File? file,
    String? detectedLabel,
  }) {
    return CreateNewThingState(
      file: file ?? this.file,
      detectedLabel: detectedLabel ?? this.detectedLabel,
    );
  }
}

