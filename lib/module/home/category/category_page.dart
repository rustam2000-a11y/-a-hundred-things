import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/utils/internet_banner_overlay.dart';
import '../../../presentation/colors.dart';

import '../../settings/bloc/account_bloc/account_bloc.dart';
import '../../things/new_things/create_new_thing_bloc.dart';
import '../bloc/home_bloc/home_bloc.dart';
import '../widget/appBar/new_custom_app_bar.dart';
import '../widget/drawer.dart';
import '../widget/type_widget/type_add_screen.dart';
import '../widget/type_widget/type_card_widget.dart';

import 'detailing_types_page.dart';

class CategoriePage extends StatefulWidget {
  const CategoriePage({
    super.key,
  });

  @override
  CategoriePageState createState() => CategoriePageState();
}

class CategoriePageState extends State<CategoriePage> {
  String? _selectedCategoryType;
  late HomeBloc _bloc;
  ValueNotifier<List<String>> selectedItemsNotifier = ValueNotifier([]);

  @override
  void initState() {
    _bloc = GetIt.I<HomeBloc>();
    _bloc.add(const HomeInitEvent());
    super.initState();
  }

  void _toggleCategoryList(bool show) {
    setState(() {});
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
          final categoryItems = state.things
              .where(
                (e) =>
                    e.typDescription.trim().isNotEmpty &&
                    e.title.trim().isEmpty,
              )
              .toList();

          return Scaffold(
            drawer: CustomDrawer(onToggleCategoryList: _toggleCategoryList),
            backgroundColor: isDarkMode ? AppColors.blackSand : Colors.white,
            appBar: const NewCustomAppBar(
              showBackButton: false,
              useTitleText: true,
              showSearchIcon: false,
              titleText: 'Categories',
            ),
            body: Stack(
              children: [
                const InternetBannerOverlay(),
                const InternetBannerOverlay(),
                Column(
                  children: [
                    const Divider(
                      thickness: 1,
                      height: 1,
                      color: Colors.black,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16),
                    ),
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
                                  builder: (context) =>
                                      BlocProvider<CreateNewThingBloc>(
                                    create: (_) =>
                                        GetIt.I<CreateNewThingBloc>(),
                                    child: const AddTypePage(),
                                  ),
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
                            final isSelected = _selectedCategoryType == type;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_selectedCategoryType == type) {
                                    _selectedCategoryType = null;
                                    _bloc.add(const HomeSelectTypeThingsEvent(
                                        field: 'type', value: ''));
                                  } else {
                                    _selectedCategoryType = type;
                                    _bloc.add(HomeSelectTypeThingsEvent(
                                        field: 'type', value: type));
                                  }
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.black
                                      : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  type,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.builder(
                        itemCount: categoryItems.length,
                        itemBuilder: (context, index) {
                          final category = categoryItems[index];
                          final typeName = category.type.isNotEmpty
                              ? category.type.first
                              : 'Unknown';

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (_) => DetailingTypesPage(
                                    initialSelectedType: typeName,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 6.0),
                              child: TypeCardWidget(
                                isSelected: selectedItemsNotifier.value
                                    .contains(category.id),
                                isDarkTheme: isDarkMode,
                                typDescription: category.typDescription,
                                imageUrl: category.imageUrl,
                                itemId: category.id,
                                type: category.type.isNotEmpty
                                    ? category.type.first
                                    : '',
                                onDeleteItem: () async {
                                  final type = category.type.isNotEmpty
                                      ? category.type.first
                                      : null;
                                  if (type != null) {
                                    await _bloc.deleteTypeAndAllThingsWithType(
                                        type, category.id);
                                    setState(() {});
                                  }
                                },
                                selectedCategoryType: _selectedCategoryType,
                                onStateUpdate: () => setState(() {}),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
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
