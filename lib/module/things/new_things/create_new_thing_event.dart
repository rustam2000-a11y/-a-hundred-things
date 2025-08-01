part of 'create_new_thing_bloc.dart';

abstract class CreateNewThingEvent extends Equatable {
  const CreateNewThingEvent();

  @override
  List<Object?> get props => [];
}

class AddImageEvent extends CreateNewThingEvent {
  const AddImageEvent(this.file);
  final File file;

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
class RemoveImageEvent extends CreateNewThingEvent {
  const RemoveImageEvent(this.index);
  final int index;

  @override
  List<Object?> get props => [index];
}
class SaveTypeEvent extends CreateNewThingEvent {

  const SaveTypeEvent({
    required this.type,
    required this.description,
    this.isEditing = false,
    this.editingItemId,
    this.files = const [],
  });
  final String type;
  final String description;
  final bool isEditing;
  final String? editingItemId;
  final List<File> files;

  @override
  List<Object?> get props => [type, description, isEditing, editingItemId, files];
}
class InitTypeFormEvent extends CreateNewThingEvent {

  const InitTypeFormEvent({this.initialType, this.initialDescription});
  final String? initialType;
  final String? initialDescription;

  @override
  List<Object?> get props => [initialType, initialDescription];
}

class TypeChangedEvent extends CreateNewThingEvent {

  const TypeChangedEvent(this.type);
  final String type;

  @override
  List<Object?> get props => [type];
}

class DescriptionChangedEvent extends CreateNewThingEvent {

  const DescriptionChangedEvent(this.description);
  final String description;

  @override
  List<Object?> get props => [description];
}
