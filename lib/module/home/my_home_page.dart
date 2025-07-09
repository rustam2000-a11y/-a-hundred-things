import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../core/utils/presentation.utils.dart';
import '../login/widget/custom_text.dart';
import '../settings/bloc/account_bloc.dart';
import 'category/category_card_widget.dart';
import 'container_with_filters.dart';
import 'home_bloc.dart';
import 'widget/appBar/new_custom_app_bar.dart';
import 'widget/drawer.dart';
import 'widget/list_of_things_widget.dart';
import 'widget/navigation_bar_widget.dart';
import 'widget/search_text_field_widget.dart';
import 'widget/things_title_list_widget.dart';
import 'widget/type_widget/type_add_screen.dart';

export 'my_home_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.toggleTheme});

  final VoidCallback? toggleTheme;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  String? _selectedCategoryType;
  late HomeBloc _bloc;
  ValueNotifier<List<String>> selectedItemsNotifier = ValueNotifier([]);

  bool _isListMode = true;
  late bool _showCategoryList = false;
  bool _showFilters = false;
  final Map<String, String> _selectedFilters = {};
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  bool _showSearchField = true;
  double _lastOffset = 0;

  @override
  void initState() {
    super.initState();
    _bloc = GetIt.I<HomeBloc>();
    _bloc.add(const HomeInitEvent());

    _searchController.addListener(() {
      setState(() {});
    });

    _scrollController.addListener(() {
      final offset = _scrollController.offset;

      if (offset > _lastOffset && offset - _lastOffset > 10) {
        // Scroll down — hide search
        if (_showSearchField) {
          setState(() {
            _showSearchField = false;
          });
        }
      } else if (offset < _lastOffset && _lastOffset - offset > 10) {
        // Scroll up — show search
        if (!_showSearchField) {
          setState(() {
            _showSearchField = true;
          });
        }
      }

      _lastOffset = offset;
    });
  }


  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }


  void _toggleCategoryList(bool show) {
    setState(() {
      _showCategoryList = show;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (_) => _bloc,
        ),
        BlocProvider<AccountBloc>(
          create: (_) => GetIt.I<AccountBloc>(),
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
                Column(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return SizeTransition(
                          sizeFactor: animation,
                          axisAlignment: -1.0,
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: _showSearchField
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
                              setState(() {
                                _showFilters = true;
                              });
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
                                    setState(() {
                                      _isListMode = true;
                                    });
                                  },
                                  child: Icon(
                                    Icons.view_list,
                                    size: 20,
                                    color: _isListMode
                                        ? Colors.black
                                        : Colors.black26,
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
                                    setState(() {
                                      _isListMode = false;
                                    });
                                  },
                                  child: Icon(
                                    Icons.view_list_outlined,
                                    size: 20,
                                    color: !_isListMode
                                        ? Colors.black
                                        : Colors.black26,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_showCategoryList)
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
                          final searchQuery = _searchController.text.toLowerCase().trim();
                          final filteredThings = state.things
                              .where((thing) =>
                          thing.title.trim().isNotEmpty &&
                              thing.title.toLowerCase().contains(searchQuery))
                              .toList();

                          return _isListMode
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
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: NavigationBarWidget(
                    isDarkMode: isDarkMode,
                    types: state.typesWithColors.keys.toList(),
                  ),
                ),
                Stack(
                  children: [
                    if (_showFilters)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showFilters = false;
                          });
                        },
                        child: Container(
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ),
                    if (_showFilters)
                      ContainerWithFilters(
                        onClose: () {
                          setState(() {
                            _showFilters = false;
                          });
                        },
                        selectedType: _selectedCategoryType,
                        selectedFilters: _selectedFilters,
                        onTypeSelected: (String field, String value) {
                          setState(() {
                            if (value.isEmpty) {
                              _selectedFilters.remove(field);
                            } else {
                              _selectedFilters[field] = value;
                            }
                            _selectedCategoryType = _selectedFilters['type'];
                            _showFilters = false;
                          });

                          _bloc.add(HomeSelectTypeThingsEvent(
                              field: field, value: value));
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

  Future<void> deleteSelectedItems(BuildContext context) async {
    try {
      for (final String itemId in selectedItemsNotifier.value) {
        await FirebaseFirestore.instance
            .collection('item')
            .doc(itemId)
            .delete();
      }
      selectedItemsNotifier.value = [];
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('The selected items have been removed')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error while deleting elements: $e')),
      );
    }
  }
}

Future<void> loadTypeColorsFromFirestore() async {
  final querySnapshot =
      await FirebaseFirestore.instance.collection('item').get();

  for (final doc in querySnapshot.docs) {
    final type = doc['type'];
    final color = doc['typeColor'];

    if (type != null && color != null) {}
  }
}
