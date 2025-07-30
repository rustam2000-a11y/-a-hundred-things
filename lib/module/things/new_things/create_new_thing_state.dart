part of 'create_new_thing_bloc.dart';

class CreateNewThingState extends Equatable {
  const CreateNewThingState({
    this.files = const [],
    this.thing,
    this.errorMessage,
    this.isSuccess = false,
  });

  final List<File> files;
  final ThingsModel? thing;
  final String? errorMessage;
  final bool isSuccess;
  @override
  List<Object?> get props => [files, thing,errorMessage, isSuccess];

  CreateNewThingState copyWith({
    List<File>? files,
    ThingsModel? thing,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return CreateNewThingState(
      files: files ?? this.files,
      thing: thing ?? this.thing,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}



