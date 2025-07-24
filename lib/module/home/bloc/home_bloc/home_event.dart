part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class HomeInitEvent extends HomeEvent {
  const HomeInitEvent();

  @override
  List<Object?> get props => [];
}

class HomeProgressEvent extends HomeEvent {
  const HomeProgressEvent({required this.isProgress});

  final bool isProgress;

  @override
  List<Object?> get props => [isProgress];
}

class HomeThingsEvent extends HomeEvent {
  const HomeThingsEvent({required this.things});

  final List<ThingsModel> things;

  @override
  List<Object?> get props => [things];
}

class HomeTypeThingsEvent extends HomeEvent {
  const HomeTypeThingsEvent({
    required this.typesWithColors,
  });

  final Map<String, String> typesWithColors;

  @override
  List<Object?> get props => [typesWithColors];
}

class HomeSelectTypeThingsEvent extends HomeEvent {
  const HomeSelectTypeThingsEvent({
    required this.field,
    required this.value,
  });

  final String field;
  final String value;

  @override
  List<Object?> get props => [field, value];
}

class DeleteThingsByTypeEvent extends HomeEvent {
  const DeleteThingsByTypeEvent({required this.type});

  final String type;

  @override
  List<Object?> get props => [type];
}

class DeleteItemByUidEvent extends HomeEvent {
  const DeleteItemByUidEvent({required this.uid});

  final String uid;

  @override
  List<Object?> get props => [uid];
}

class DeleteItemsByUidsEvent extends HomeEvent {

  const DeleteItemsByUidsEvent({required this.uids});
  final List<String> uids;

  @override
  List<Object?> get props => [uids];
}
class ToggleListModeEvent extends HomeEvent {
  const ToggleListModeEvent(this.isListMode);
  final bool isListMode;

  @override
  List<Object?> get props => [isListMode];
}

class ToggleSearchVisibilityEvent extends HomeEvent {
  const ToggleSearchVisibilityEvent(this.visible);
  final bool visible;

  @override
  List<Object?> get props => [visible];
}

class ToggleFiltersVisibilityEvent extends HomeEvent {
  const ToggleFiltersVisibilityEvent(this.visible);
  final bool visible;

  @override
  List<Object?> get props => [visible];
}

class ToggleCategoryListEvent extends HomeEvent {
  const ToggleCategoryListEvent(this.visible);
  final bool visible;

  @override
  List<Object?> get props => [visible];
}

class UpdateSelectedCategoryEvent extends HomeEvent {
  const UpdateSelectedCategoryEvent(this.category);
  final String? category;

  @override
  List<Object?> get props => [category];
}

class UpdateSelectedFiltersEvent extends HomeEvent {
  const UpdateSelectedFiltersEvent(this.filters);
  final Map<String, String> filters;

  @override
  List<Object?> get props => [filters];
}

class SetHideNavigationBarEvent extends HomeEvent {
  const SetHideNavigationBarEvent(this.hide);
  final bool hide;

  @override
  List<Object?> get props => [hide];
}

class SetLoadingStateEvent extends HomeEvent {
  const SetLoadingStateEvent(this.isLoading);
  final bool isLoading;

  @override
  List<Object?> get props => [isLoading];
}

class UpdateSelectedItemsEvent extends HomeEvent {
  const UpdateSelectedItemsEvent(this.selectedItemIds);
  final List<String> selectedItemIds;

  @override
  List<Object?> get props => [selectedItemIds];
}
