part of 'max_items_bloc.dart';

class MaxItemsState extends Equatable {
  const MaxItemsState({
    this.maxItems = 1000,
    this.isSpecial = false,
    this.errorText,
    this.done = false,
  });

  final int maxItems;
  final bool isSpecial;
  final String? errorText;
  final bool done;

  MaxItemsState copyWith({
    int? maxItems,
    bool? isSpecial,
    String? errorText,
    bool? done,
  }) {
    return MaxItemsState(
      maxItems: maxItems ?? this.maxItems,
      isSpecial: isSpecial ?? this.isSpecial,
      errorText: errorText,
      done: done ?? false,
    );
  }

  @override
  List<Object?> get props => [maxItems, isSpecial, errorText, done];
}
