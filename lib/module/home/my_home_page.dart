import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../core/utils/presentation.utils.dart';
import '../../presentation/colors.dart';
import '../login/widget/custom_text.dart';
import 'home_bloc.dart';
import 'widget/appBar/new_custom_app_bar.dart';
import 'widget/category_card_widget.dart';
import 'widget/drawer.dart';
import 'widget/list_of_things_widget.dart';
import 'widget/navigation_bar_widget.dart';
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
  bool _showCategoryList = false;

  @override
  void initState() {
    _bloc = GetIt.I<HomeBloc>();
    _bloc.add(const HomeInitEvent());
    super.initState();
  }
  void _toggleCategoryList(bool show) {
    setState(() {
      _showCategoryList = show;
    });
  }


  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<HomeBloc, HomeState>(
      bloc: _bloc,
      builder: (context, state) {
        final filteredThings = state.things
            .where((e) => e.title.trim().isNotEmpty)
            .toList();

        return Scaffold(
          drawer: CustomDrawer(
            onToggleCategoryList: _toggleCategoryList,
          ),
          backgroundColor: isDarkMode ? AppColors.blackSand : Colors.white,
          appBar: const NewCustomAppBar(showBackButton: false),
          body: Stack(
            children: [
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText5(
                          text: 'All Your Things',
                          fontSize: 20,
                        ),
                      ],
                    ),
                  ),
                  const Divider(thickness: 1, height: 1, color: Colors.black),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.import_export, size: 24),
                            SizedBox(width: 4),
                            CustomText5(text: 'FILTER', fontSize: 20),
                          ],
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
                                  size: 18,
                                  color: _isListMode ? Colors.black : Colors.black26,
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 20,
                                color: Colors.black26,
                                margin: const EdgeInsets.symmetric(horizontal: 8),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isListMode = false;
                                  });
                                },
                                child: Icon(
                                  Icons.view_list_outlined,
                                  size: 18,
                                  color: !_isListMode ? Colors.black : Colors.black26,
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
                              padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                  Icon(Icons.add, color: Colors.white, size: 20),
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
                                  } else {
                                    _selectedCategoryType = category;
                                  }
                                  _bloc.add(HomeSelectTypeThingsEvent(
                                    selectedTypeThings: _selectedCategoryType,
                                  ));
                                });
                              },
                              onDeleteThings: () {
                                _bloc.add(DeleteThingsByTypeEvent(type: type));
                              },
                              type: type,
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  const SizedBox(height: 12),


                  Expanded(
                    child: _isListMode
                        ? ThingsTypeListWidget(
                      things: filteredThings,
                      selectedCategoryType: _selectedCategoryType,
                      selectedItemsNotifier: selectedItemsNotifier,
                      onStateUpdate: () => setState(() {}),
                      onDeleteItem: (uid) =>
                          _bloc.add(DeleteItemByUidEvent(uid: uid)),
                    )
                        : NewListOfTitles(
                      title: filteredThings.map((e) => e.title!).toList(),
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
            ],
          ),
        );
      },
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
        const SnackBar(content: Text('Выбранные элементы удалены')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при удалении элементов: $e')),
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

    if (type != null && color != null) {

    }
  }
}
