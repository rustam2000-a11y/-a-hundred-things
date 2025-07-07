part of 'create_new_thing_bloc.dart';

abstract class CreateNewThingEvent extends Equatable {
  const CreateNewThingEvent();

  @override
  List<Object?> get props => [];
}

class SetNewImageEvent extends CreateNewThingEvent {

  const SetNewImageEvent({required this.file});
  final File? file;

  @override
  List<Object?> get props => [file];
}

class ChangeImageEvent extends CreateNewThingEvent {

  const ChangeImageEvent(this.context, this.onTitleDetected);
  final BuildContext context;
  final void Function(String detectedTitle) onTitleDetected;

  @override
  List<Object?> get props => [context];
}

class LoadThingEvent extends CreateNewThingEvent {

  const LoadThingEvent(this.docId);
  final String docId;

  @override
  List<Object?> get props => [docId];
}

class SaveThingEvent extends CreateNewThingEvent {

  const SaveThingEvent(this.model);
  final ThingsModel model;

  @override
  List<Object?> get props => [model];
}

class ToggleFavoriteEvent extends CreateNewThingEvent {

  const ToggleFavoriteEvent(this.docId, this.isFavorite);
  final String docId;
  final bool isFavorite;

  @override
  List<Object?> get props => [docId, isFavorite];
}
