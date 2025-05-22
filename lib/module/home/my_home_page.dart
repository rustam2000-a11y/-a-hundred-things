import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../core/utils/presentation.utils.dart';
import '../../generated/l10n.dart';
import '../../presentation/colors.dart';
import '../login/widget/custom_text.dart';
import 'home_bloc.dart';
import 'widget/category_card_widget.dart';
import 'widget/drawer.dart';
import 'widget/navigation_bar_widget.dart';
import 'widget/new_custom_app_bar.dart';
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
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<HomeBloc, HomeState>(
      bloc: _bloc,
      builder: (context, state) {
        return Scaffold(
          drawer: const CustomDrawer(),
          backgroundColor: isDarkMode ? AppColors.blackSand : Colors.white,
          appBar: const NewCustomAppBar(
            showBackButton :false,
          ),
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
                  const Divider(
                    thickness: 1,
                    height: 1,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 16),
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
                              } else {
                                _selectedCategoryType = category;
                              }
                              _bloc.add(HomeSelectTypeThingsEvent(
                                  selectedTypeThings: _selectedCategoryType));
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
                  const SizedBox(height: 12),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 100),
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: state.things.length,
                        itemBuilder: (context, index) {
                          final item = state.things[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ThingsCardWidget(
                              itemId: item.id,
                              title: item.title,
                              description: item.description,
                              type: item.type,
                              imageUrl: item.imageUrl,
                              selectedCategoryType: _selectedCategoryType,
                              onStateUpdate: () {
                                setState(() {});
                              },
                              quantity: item.quantity,
                              onDeleteItem: () {
                                _bloc.add(DeleteItemByUidEvent(uid: item.id));
                              },
                              selectedItemsNotifier: selectedItemsNotifier,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: NavigationBarWidget(isDarkMode: isDarkMode,),
              ),
            ],
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


