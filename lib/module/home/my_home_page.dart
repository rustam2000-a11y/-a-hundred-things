import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../core/utils/presentation.utils.dart';
import '../../generated/l10n.dart';
import '../../presentation/colors.dart';
import 'home_bloc.dart';
import 'widget/category_card_widget.dart';
import 'widget/custom_app_bar.dart';
import 'widget/show_add_item_bottom_sheet.dart';
import 'widget/things_card_item.dart';

export 'my_home_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.toggleTheme});

  final VoidCallback toggleTheme;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  bool isLoading = false;
  List<String> selectedItems = [];
  String? _selectedCategoryType;
  late HomeBloc _bloc;
  ValueNotifier<List<String>> selectedItemsNotifier = ValueNotifier([]);

  @override
  void initState() {
    _bloc = GetIt.I<HomeBloc>();
    _bloc.add(const HomeInitEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<HomeBloc, HomeState>(
      bloc: _bloc,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: isDarkMode ? AppColors.blackSand : Colors.white,
          body: CustomScrollView(
            slivers: [
            CustomAppBar(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            toggleTheme: widget.toggleTheme,
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: screenHeight * 0.03,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                  S.of(context).ategories,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: screenHeight * 0.02,
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _FixedHeaderDelegate(
                  minHeight: 50,
                  maxHeight: 50,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.blackSand
                            : Colors.white,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.02),
                          children: state.typesWithColors.entries.map((entry) {
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
                                    _bloc.add(HomeSelectTypeThingsEvent(
                                        selectedTypeThings:
                                            _selectedCategoryType));
                                  } else {
                                    _selectedCategoryType = category;
                                    _bloc.add(HomeSelectTypeThingsEvent(
                                        selectedTypeThings:
                                            _selectedCategoryType));
                                  }
                                });
                              },
                              onDeleteThings: () {
                                _bloc.add(DeleteThingsByTypeEvent(type: type));
                              },
                              isDarkMode: isDarkMode,
                              color: color,
                              type: type,
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverFillRemaining(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: screenHeight * 0.02,
                  ).add(
                    EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02,
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: state.things.length,
                          itemBuilder: (context, index) {
                            final item = state.things[index];
                            return Padding(
                                padding: EdgeInsets.only(
                                    bottom: screenHeight * 0.01),
                                child: ThingsCardWidget(
                                  itemId: item.id,
                                  title: item.title,
                                  description: item.description,
                                  type: item.type,
                                  color: item.color,
                                  imageUrl: item.imageUrl,
                                  selectedCategoryType: _selectedCategoryType,
                                  onStateUpdate: () {
                                    setState(() {});
                                  },
                                  quantity: item.quantity,
                                  onDeleteItem: () {
                                    _bloc.add(
                                        DeleteItemByUidEvent(uid: item.id));
                                  },
                                  selectedItemsNotifier: selectedItemsNotifier,
                                ));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: SafeArea(
            child: ValueListenableBuilder<List<String>>(
              valueListenable: selectedItemsNotifier,
              builder: (context, selectedItems, child) {
                final isDarkTheme =
                    Theme.of(context).brightness == Brightness.dark;

                return selectedItems.isNotEmpty
                    ? FloatingActionButton(
                        onPressed: () {
                          deleteSelectedItems(context);
                        },
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.delete),
                      )
                    : Container(
                        width: 60,
                        height: 60,
                        decoration: isDarkTheme
                            ? BoxDecoration(
                                gradient: AppColors.blueGradient,
                                borderRadius: BorderRadius.circular(10),
                              )
                            : null,
                        child: FloatingActionButton(
                          onPressed: () {
                            showAddItemBottomSheet(context);
                          },
                          backgroundColor: isDarkMode
                              ? Colors.transparent
                              : AppColors.orangeSand,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> deleteSelectedItems(BuildContext context) async {
    try {
      for (String itemId in selectedItemsNotifier.value) {
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

  for (var doc in querySnapshot.docs) {
    final type = doc['type'];
    final color = doc['typeColor'];

    if (type != null && color != null) {
      typeColorsCache[type] = color;
    }
  }
}

class _FixedHeaderDelegate extends SliverPersistentHeaderDelegate {

  _FixedHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(_FixedHeaderDelegate oldDelegate) {
    return oldDelegate.maxHeight != maxHeight ||
        oldDelegate.minHeight != minHeight ||
        oldDelegate.child != child;
  }
}
