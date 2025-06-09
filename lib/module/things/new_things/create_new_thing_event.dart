part of 'create_new_thing_bloc.dart';

sealed class CreateNewThingEvent extends Equatable {
  const CreateNewThingEvent();
}

class SetNewImageEvent extends CreateNewThingEvent {
  const SetNewImageEvent({required this.file});

  final File? file;
  @override
  List<Object?> get props => [file];
}

class ChangeImageEvent extends CreateNewThingEvent {
  const ChangeImageEvent(this.context);

  final BuildContext context;

  @override
  List<Object?> get props => [context];
}
