import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../core/utils/presentation.utils.dart';
import '../../../presentation/colors.dart';
import '../../login/widget/custom_text.dart';
import '../../settings/bloc/account_bloc.dart';
import '../home_bloc.dart';
import '../widget/appBar/new_custom_app_bar.dart';
import '../widget/drawer.dart';
import '../widget/type_widget/type_add_screen.dart';
import '../widget/type_widget/type_card_widget.dart';
import 'category_card_widget.dart';
import 'detailing_types_page.dart';
import 'new_list_of_types_widget.dart';

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
          final existingTypes =
              state.things.map((e) => e.type.trim().toLowerCase()).toSet();

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
                Column(
                  children: [
                    const Divider(
                      thickness: 1,
                      height: 1,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        //
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.import_export, size: 24),
                              SizedBox(width: 4),
                              CustomText5(
                                text: 'FILTER',
                                fontSize: 20,
                              ),
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
                                    size: 18,
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
                            ...state.typesWithColors.entries
                                .where((entry) => existingTypes
                                    .contains(entry.key.trim().toLowerCase()))
                                .map((entry) {
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
                                      _bloc.add(const HomeSelectTypeThingsEvent(
                                          field: 'type', value: ''));
                                    } else {
                                      _selectedCategoryType = category;
                                      _bloc.add(HomeSelectTypeThingsEvent(
                                          field: 'type',
                                          value: _selectedCategoryType!));
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
                          ]),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: _isListMode
                          ? Builder(
                              builder: (context) {
                                final filteredThingsByUniqueType =
                                    <String, dynamic>{};

                                for (final thing in state.things) {
                                  final isTypeMatching =
                                      _selectedCategoryType == null ||
                                          thing.type == _selectedCategoryType;
                                  final hasTypDescription =
                                      thing.typDescription.trim().isNotEmpty;

                                  if (isTypeMatching && hasTypDescription) {
                                    filteredThingsByUniqueType[thing.type] ??=
                                        thing;
                                  }
                                }

                                final uniqueThings =
                                    filteredThingsByUniqueType.values.toList();

                                return ListView.builder(
                                  itemCount: uniqueThings.length,
                                  itemBuilder: (context, index) {
                                    final thing = uniqueThings[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute<void>(
                                            builder: (_) => DetailingTypesPage(
                                              initialSelectedType: thing.type,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 6.0),
                                        child: TypeCardWidget(
                                          isSelected: selectedItemsNotifier
                                              .value
                                              .contains(thing.id),
                                          isDarkTheme: isDarkMode,
                                          typDescription:
                                              thing.typDescription ?? '',
                                          imageUrl: thing.imageUrl,
                                          itemId: thing.id,
                                          type: thing.type,
                                          onDeleteItem: () => _bloc.add(
                                              DeleteItemByUidEvent(
                                                  uid: thing.id)),
                                          selectedCategoryType:
                                              _selectedCategoryType,
                                          onStateUpdate: () => setState(() {}),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            )
                          : NewListOfTypes(
                              types: state.typesWithColors.keys.toList(),
                              onTypeTap: (String tappedType) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (_) => DetailingTypesPage(
                                      initialSelectedType: tappedType,
                                    ),
                                  ),
                                );
                              },
                              onDeleteType: (String typeToDelete) {
                                _bloc.add(DeleteThingsByTypeEvent(
                                    type: typeToDelete));
                              },
                            ),
                    ),
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
