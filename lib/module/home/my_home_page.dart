import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/internet_banner_overlay.dart';
import '../../core/utils/presentation.utils.dart';
import '../login/widget/button_basic.dart';
import '../login/widget/custom_text.dart';
import '../settings/bloc/account_bloc/account_bloc.dart';
import 'bloc/home_bloc/home_bloc.dart';
import 'bloc/progress_bar_bloc/progress_bar_bloc.dart';
import 'category/category_card_widget.dart';
import 'container_with_filters.dart';
import 'widget/appBar/new_custom_app_bar.dart';
import 'widget/drawer.dart';
import 'widget/list_of_things_widget.dart';
import 'widget/navigation_bar_widget.dart';
import 'widget/search_text_field_widget.dart';
import 'widget/things_title_list_widget.dart';
import 'widget/type_widget/type_add_screen.dart';
export 'my_home_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.toggleTheme,
    this.hideNavigationBar = false,
  });

  final VoidCallback? toggleTheme;
  final bool hideNavigationBar;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  String? _selectedCategoryType;
  late HomeBloc _bloc;
  ValueNotifier<List<String>> selectedItemsNotifier = ValueNotifier([]);


  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  double _lastOffset = 0;
  late bool _hideNavigationBar;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _bloc = GetIt.I<HomeBloc>();
    _bloc.add(const HomeInitEvent());

    _hideNavigationBar = false;
    _loadIsSpecialFromPrefs();

    _searchController.addListener(() {
      setState(() {});
    });

    _scrollController.addListener(() {
      final offset = _scrollController.offset;

      final showSearchField = _bloc.state.showSearchField;

      if (offset > _lastOffset && offset - _lastOffset > 5) {
        if (showSearchField) {
          _searchFocusNode.unfocus();
          _bloc.add(const ToggleSearchVisibilityEvent(false));
        }
      } else if (offset < _lastOffset && _lastOffset - offset > 5) {
        if (!showSearchField) {
          _bloc.add(const ToggleSearchVisibilityEvent(true));
        }
      }

      _lastOffset = offset;
    });

  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadIsSpecialFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final isSpecial = prefs.getBool('isSpecial') ?? false;

    setState(() {
      _hideNavigationBar = isSpecial;
      _isLoading = false;
    });
  }

  void _toggleCategoryList(bool show) {
    _bloc.add(ToggleCategoryListEvent(show));

  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    if (_isLoading) {
      return const Scaffold(
        body: SizedBox(),
      );
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (_) => _bloc,
        ),
        BlocProvider<AccountBloc>(
          create: (_) => GetIt.I<AccountBloc>(),
        ),
        BlocProvider<ProgressBarBloc>(
          create: (_) => GetIt.I<ProgressBarBloc>()..add(LoadProgressBar()),
        ),
      ],
      child: BlocBuilder<HomeBloc, HomeState>(
        bloc: _bloc,
        builder: (context, state) {
          final filteredThings =
          state.things.where((e) => e.title.trim().isNotEmpty).toList();

          return Scaffold(
            drawer: CustomDrawer(
              onToggleCategoryList: _toggleCategoryList,
            ),
            appBar: const NewCustomAppBar(
              showBackButton: false,
              showSearchIcon: false,
            ),
            body: Stack(
              children: [
                const InternetBannerOverlay(),
                Column(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return SizeTransition(
                          sizeFactor: animation,
                          axisAlignment: -1.0,
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: state.showSearchField
                          ? SearchTextFieldWidget(
                        key: const ValueKey('search_field_visible'),
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        isDarkMode: isDarkMode,
                      )
                          : const SizedBox(
                        key: ValueKey('search_field_hidden'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _bloc.add(const ToggleFiltersVisibilityEvent(true));

                            },
                            child: const Row(
                              children: [
                                Icon(Icons.import_export, size: 24),
                                SizedBox(width: 4),
                                CustomText5(text: 'FILTER', fontSize: 20),
                              ],
                            ),
                          ),
                          Container(
                            width: 74,
                            height: 32,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _bloc.add(const ToggleListModeEvent(true));
                                  },
                                  child: Icon(
                                    Icons.view_list,
                                    size: 20,
                                    color: state.isListMode ? Colors.black : Colors.black26,
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 20,
                                  color: Colors.black26,
                                  margin:
                                  const EdgeInsets.symmetric(horizontal: 8),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _bloc.add(const ToggleListModeEvent(false));
                                  },
                                  child: Icon(
                                    Icons.view_list_outlined,
                                    size: 20,
                                    color: !state.isListMode ? Colors.black : Colors.black26,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (state.showCategoryList)
                      SizedBox(
                        height: 50,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: 16),
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (context) => const AddTypePage(),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding:
                                const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                alignment: Alignment.center,
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Add',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Icon(Icons.add,
                                        color: Colors.white, size: 20),
                                  ],
                                ),
                              ),
                            ),
                            ...state.typesWithColors.entries.map((entry) {
                              final type = entry.key;
                              final color = entry.value.isEmpty
                                  ? PresentationUtils.getRandomColor()
                                  : entry.value;

                              return CategoryCardWidget(
                                selectedCategoryType: _selectedCategoryType,
                                onChangeCategory: (String? category) {
                                  setState(() {
                                    if (_selectedCategoryType == category) {
                                      _selectedCategoryType = null;
                                      _bloc.add(
                                        const HomeSelectTypeThingsEvent(
                                          field: 'type',
                                          value: '',
                                        ),
                                      );
                                    } else {
                                      _selectedCategoryType = category;
                                      _bloc.add(
                                        HomeSelectTypeThingsEvent(
                                          field: 'type',
                                          value: _selectedCategoryType!,
                                        ),
                                      );
                                    }
                                  });
                                },
                                onDeleteThings: () {
                                  _bloc
                                      .add(DeleteThingsByTypeEvent(type: type));
                                },
                                type: type,
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          final searchQuery =
                          _searchController.text.toLowerCase().trim();
                          final filteredThings = state.things
                              .where((thing) =>
                          thing.title.trim().isNotEmpty &&
                              thing.title
                                  .toLowerCase()
                                  .contains(searchQuery))
                              .toList();

                          return state.isListMode
                              ? ThingsTypeListWidget(
                            controller: _scrollController,
                            things: filteredThings,
                            selectedCategoryType: _selectedCategoryType,
                            selectedItemsNotifier: selectedItemsNotifier,
                            onStateUpdate: () => setState(() {}),
                            onDeleteItem: (uid) =>
                                _bloc.add(DeleteItemByUidEvent(uid: uid)),
                          )
                              : NewListOfTitles(
                            controller: _scrollController,
                            things: filteredThings,
                            allTypes: state.typesWithColors.keys.toList(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: 16,
                  bottom: _hideNavigationBar ? 40 : 110,
                  child: ValueListenableBuilder<List<String>>(
                    valueListenable: selectedItemsNotifier,
                    builder: (context, selectedItems, _) {
                      return SquareAddButton(
                        types: state.typesWithColors.keys.toList(),
                        context: context,
                        isAnyItemSelected: selectedItems.isNotEmpty,
                        onDeleteSelected: () {
                          if (selectedItemsNotifier.value.isNotEmpty) {
                            _bloc.add(DeleteItemsByUidsEvent(uids: selectedItemsNotifier.value));
                            selectedItemsNotifier.value = [];

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('The selected items have been removed')),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: BlocBuilder<ProgressBarBloc, ProgressBarState>(
                    builder: (context, progressState) {
                      return NavigationBarWidget(
                        isDarkMode: isDarkMode,
                        types: state.typesWithColors.keys.toList(),
                        hide: _hideNavigationBar,
                        maxItems: progressState.maxItems,
                        totalQuantity: progressState.totalQuantity,
                      );
                    },
                  ),
                ),
                Stack(
                  children: [
                    if (state.showFilters)
                      GestureDetector(
                        onTap: () {
                          _bloc.add(const ToggleFiltersVisibilityEvent(true));
                        },

                        child: Container(
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ),
                    if (state.showFilters)
                      ContainerWithFilters(
                        onClose: () {
                          _bloc.add(const ToggleFiltersVisibilityEvent(false));
                        },
                        selectedType: state.selectedCategoryType,
                        selectedFilters: state.selectedFilters,

                        onTypeSelected: (String field, String value) {
                          final newFilters = Map<String, String>.from(state.selectedFilters);

                          if (value.isEmpty) {
                            newFilters.remove(field);
                          } else {
                            newFilters[field] = value;
                          }

                          _bloc..add(UpdateSelectedCategoryEvent(newFilters['type']))
                          ..add(UpdateSelectedFiltersEvent(newFilters))
                          ..add(HomeSelectTypeThingsEvent(field: field, value: value))
                          ..add(const ToggleFiltersVisibilityEvent(false));
                        },

                      ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

