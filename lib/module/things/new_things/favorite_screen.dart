import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../model/things_model.dart';
import '../../../presentation/colors.dart';
import '../../home/home_bloc.dart';
import '../../home/widget/appBar/new_custom_app_bar.dart';
import '../../home/widget/drawer.dart';
import '../../home/widget/list_of_things_widget.dart';
import '../../home/widget/navigation_bar_widget.dart';

import '../../login/widget/custom_text.dart';

class FavorieteScreen extends StatefulWidget {
  const FavorieteScreen({
    super.key,
  });

  @override
  FavorieteScreenState createState() => FavorieteScreenState();
}

class FavorieteScreenState extends State<FavorieteScreen> {
  String? _selectedCategoryType;
  late HomeBloc _bloc;
  ValueNotifier<List<String>> selectedItemsNotifier = ValueNotifier([]);


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
                      text: 'Favorites',
                      fontSize: 20,
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 1, height: 1, color: Colors.black),

              const SizedBox(height: 12),


              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('item')
                      .where('favorites', isEqualTo: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final docs = snapshot.data?.docs ?? [];

                    final things = docs
                        .map((e) => ThingsModel.fromJson(e.data() as Map<String, dynamic>)
                        .copyWith(id: e.id))
                        .where((e) => e.title.trim().isNotEmpty)
                        .toList();

                    return ThingsTypeListWidget(
                      things: things,
                      selectedCategoryType: _selectedCategoryType,
                      selectedItemsNotifier: selectedItemsNotifier,
                      onDeleteItem: (uid) => _bloc.add(DeleteItemByUidEvent(uid: uid)),
                      onStateUpdate: () {},
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
              types: _bloc.state.typesWithColors.keys.toList(),
            ),
          ),
        ],
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
        const SnackBar(content: Text('The selected items have been removed.')),
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
