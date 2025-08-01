part of 'create_new_thing_bloc.dart';

class CreateNewThingState extends Equatable {
  const CreateNewThingState({
    this.files = const [],
    this.thing,
    this.errorMessage,
    this.isSuccess = false,
    this.type = '',
    this.description = '',
  });

  final List<File> files;
  final ThingsModel? thing;
  final String? errorMessage;
  final bool isSuccess;

  final String type;
  final String description;

  bool get isFormFilled => type.trim().isNotEmpty && description.trim().isNotEmpty;

  @override
  List<Object?> get props => [
    files,
    thing,
    errorMessage,
    isSuccess,
    type,
    description,
  ];

  CreateNewThingState copyWith({
    List<File>? files,
    ThingsModel? thing,
    String? errorMessage,
    bool? isSuccess,
    String? type,
    String? description,
  }) {
    return CreateNewThingState(
      files: files ?? this.files,
      thing: thing ?? this.thing,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      type: type ?? this.type,
      description: description ?? this.description,
    );
  }
}


