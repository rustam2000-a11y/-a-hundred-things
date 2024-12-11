export 'home_widget.dart';
import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import '../../../main.dart';
import '../../../presentation/colors.dart';
import '../../settings/widget/user_profile_screen.dart';
import 'build_card_item.dart';
import 'icon_home.dart';
import 'show_add_item_bottom_sheet.dart';
import 'show_search_bottom_sheet.dart';

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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.blackSand : Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: screenHeight * 0.15,
            backgroundColor: isDarkMode
                ? AppColors.blackSand
                : Theme.of(context).primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: EdgeInsets.only(
                  top: screenHeight * 0.07,
                  left: screenWidth * 0.05,
                  right: screenWidth * 0.05,
                  bottom: screenHeight * 0.03,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: isDarkMode
                      ? AppColors.blackSand
                      : Theme.of(context).primaryColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'assets/images/IMG_4650(1).png',
                                width: screenWidth * 0.09,
                                height: screenWidth * 0.09,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 2),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'assets/images/100 Things(3).png',
                                width: screenWidth * 0.22,
                                height: screenWidth * 0.04,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 10),
                            ReusableIconButton(
                              icon: Icons.search_rounded,
                              onPressed: () {
                                showSearchBottomSheet(context);
                              },
                              screenWidth: screenWidth,
                              borderRadius: 10,
                            ),
                            const SizedBox(width: 4),
                            const SizedBox(width: 10),
                            ReusableIconButton(
                              icon: Icons.more_vert,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                    builder: (context) => UserProfileScreen(
                                      toggleTheme: () {
                                        final state = context
                                            .findAncestorStateOfType<MyAppState>();
                                        state?.toggleTheme();
                                      },
                                    ),
                                  ),
                                );
                              },
                              screenWidth: screenWidth,
                              borderRadius: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('item')
                          .where('userId',
                          isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        int totalQuantity = 0;

                        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                          totalQuantity = snapshot.data!.docs.fold<int>(
                            0,
                                (accumulator, doc) {
                              final quantity = doc['quantity'] as int? ?? 1;
                              return accumulator + quantity;
                            },
                          );
                        }

                        final progress = (totalQuantity / 100).clamp(0.0, 1.0);
                        final isDarkTheme =
                            Theme.of(context).brightness == Brightness.dark;

                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                height: 10,
                                child: LinearProgressIndicator(
                                  value: progress,
                                  backgroundColor: AppColors.lightviolet,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    isDarkTheme
                                        ? AppColors.blueSand
                                        : AppColors.violetSand,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: progress *
                                  (MediaQuery.of(context).size.width * 0.85) -
                                  10,
                              top: -30,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: isDarkMode
                                          ? AppColors.blueSand
                                          : AppColors.violetSand,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    child: Text(
                                      '${(progress * 100).toInt()}%',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 24,
                                    height: 23,
                                    decoration: BoxDecoration(
                                      color: isDarkMode
                                          ? AppColors.blueSand
                                          : Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: AppColors.violetSand, width: 4),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
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
                S.of(context).or,
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
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('item')
                    .where('userId',
                    isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No items found.'));
                  }

                  final items = snapshot.data!.docs;
                  final typesWithColors =
                  items.fold<Map<String, String>>({}, (map, item) {
                    final type = item['type'] as String;
                    final color =
                        item['typeColor'] as String? ?? getRandomColor();
                    map[type] = color;
                    return map;
                  });

                  return ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(left: screenWidth * 0.02),
                    children: typesWithColors.entries.map((entry) {
                      return _buildCategoryButton(
                        entry.key,
                        entry.value,
                        isDarkMode,
                      );
                    }).toList(),
                  );
                },
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
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('item')
                          .where('userId',
                          isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(child: Text('No items found.'));
                        }

                        final items = snapshot.data!.docs.where((item) {
                          if (_selectedCategoryType == null) return true;
                          return item['type'] == _selectedCategoryType;
                        }).toList();

                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            final data = item.data() as Map<String, dynamic>;
                            final quantity = data['quantity'] ?? 1;

                            return Padding(
                              padding:
                              EdgeInsets.only(bottom: screenHeight * 0.01),
                              child: buildCardItem(
                                context: context,
                                itemId: item.id,
                                title: data['title'] ?? 'Unknown Title',
                                description:
                                data['description'] ?? 'No Description',
                                type: data['type'] ?? 'Unknown Type',
                                color: data['color'] ?? '#FFFFFF',
                                imageUrl: data['imageUrl'] as String?,
                                selectedCategoryType: _selectedCategoryType,
                                onStateUpdate: () {
                                  setState(() {});
                                },
                                quantity: quantity,
                              ),
                            );
                          },
                        );
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
            final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

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
  }

  Widget _buildCategoryButton(String type, String color, bool isDarkMode) {
    final backgroundColor = getColorFromHex(color) ?? AppColors.silverColor;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedCategoryType == type) {
            _selectedCategoryType = null;
          } else {
            _selectedCategoryType = type;
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: isDarkMode ? AppColors.whiteToBlackGradient : null,
            color: !isDarkMode ? backgroundColor : null,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                type,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () async {
                  await _deleteItemsByType(type);
                },
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteItemsByType(String type) async {
    try {
      final items = await FirebaseFirestore.instance
          .collection('item')
          .where('type', isEqualTo: type)
          .get();

      for (final doc in items.docs) {
        await doc.reference.delete();
      }

      setState(() {
        _selectedCategoryType = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Категория "$type" удалена.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при удалении категории: $e')),
      );
    }
  }
}

String getRandomColor() {
  final random = Random();
  return '#${random.nextInt(0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
}

Color? getColorFromHex(String? hexColor) {
  if (hexColor == null || !hexColor.startsWith('#')) return null;
  try {
    return Color(int.parse(hexColor.replaceFirst('#', '0xff')));
  } catch (e) {
    return null;
  }
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
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _FixedHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  Widget build( BuildContext context, double shrinkOffset, bool overlapsContent) {
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