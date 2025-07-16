part of 'max_items_bloc.dart';

abstract class MaxItemsEvent extends Equatable {
  const MaxItemsEvent();
}

class MaxItemsInitEvent extends MaxItemsEvent {
  const MaxItemsInitEvent({required this.initialValue});
  final int initialValue;
  @override
  List<Object?> get props => [initialValue];
}

class MaxItemsChangedEvent extends MaxItemsEvent {
  const MaxItemsChangedEvent(this.value);
  final int value;
  @override
  List<Object?> get props => [value];
}

class MaxItemsSpecialChangedEvent extends MaxItemsEvent {
  const MaxItemsSpecialChangedEvent(this.value);
  final bool value;
  @override
  List<Object?> get props => [value];
}

class MaxItemsSubmittedEvent extends MaxItemsEvent {
  const MaxItemsSubmittedEvent();
  @override
  List<Object?> get props => [];
}
