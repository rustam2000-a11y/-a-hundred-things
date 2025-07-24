part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState({
    this.isProgress = false,
    this.isLoading = true,
    this.showSearchField = true,
    this.isListMode = true,
    this.showFilters = false,
    this.showCategoryList = false,
    this.hideNavigationBar = false,
    this.selectedCategoryType,
    this.selectedFilters = const {},
    this.selectedItemIds = const [],
    this.things = const [],
    this.typeThings = const [],
    this.typesWithColors = const {},
  });

  final bool isProgress;
  final bool isLoading;
  final bool showSearchField;
  final bool isListMode;
  final bool showFilters;
  final bool showCategoryList;
  final bool hideNavigationBar;

  final String? selectedCategoryType;
  final Map<String, String> selectedFilters;
  final List<String> selectedItemIds;

  final List<ThingsModel> things;
  final List<ThingsModel> typeThings;
  final Map<String, String> typesWithColors;

  @override
  List<Object?> get props => [
    isProgress,
    isLoading,
    showSearchField,
    isListMode,
    showFilters,
    showCategoryList,
    hideNavigationBar,
    selectedCategoryType,
    selectedFilters,
    selectedItemIds,
    things,
    typeThings,
    typesWithColors,
  ];

  HomeState copyWith({
    bool? isProgress,
    bool? isLoading,
    bool? showSearchField,
    bool? isListMode,
    bool? showFilters,
    bool? showCategoryList,
    bool? hideNavigationBar,
    String? selectedCategoryType,
    Map<String, String>? selectedFilters,
    List<String>? selectedItemIds,
    List<ThingsModel>? things,
    List<ThingsModel>? typeThings,
    Map<String, String>? typesWithColors,
  }) {
    return HomeState(
      isProgress: isProgress ?? this.isProgress,
      isLoading: isLoading ?? this.isLoading,
      showSearchField: showSearchField ?? this.showSearchField,
      isListMode: isListMode ?? this.isListMode,
      showFilters: showFilters ?? this.showFilters,
      showCategoryList: showCategoryList ?? this.showCategoryList,
      hideNavigationBar: hideNavigationBar ?? this.hideNavigationBar,
      selectedCategoryType: selectedCategoryType ?? this.selectedCategoryType,
      selectedFilters: selectedFilters ?? this.selectedFilters,
      selectedItemIds: selectedItemIds ?? this.selectedItemIds,
      things: things ?? this.things,
      typeThings: typeThings ?? this.typeThings,
      typesWithColors: typesWithColors ?? this.typesWithColors,
    );
  }
}
