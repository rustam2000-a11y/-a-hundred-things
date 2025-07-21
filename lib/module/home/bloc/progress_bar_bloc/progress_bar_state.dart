part of 'progress_bar_bloc.dart';

class ProgressBarState extends Equatable {

  const ProgressBarState({
    this.maxItems = 100,
    this.totalQuantity = 0,
  });
  final int maxItems;
  final int totalQuantity;

  ProgressBarState copyWith({
    int? maxItems,
    int? totalQuantity,
  }) {
    return ProgressBarState(
      maxItems: maxItems ?? this.maxItems,
      totalQuantity: totalQuantity ?? this.totalQuantity,
    );
  }

  @override
  List<Object> get props => [maxItems, totalQuantity];
}
