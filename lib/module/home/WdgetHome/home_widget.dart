export 'home_widget.dart';
import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../ Settings/widget/user_profile_screen.dart';
import '../../../generated/l10n.dart';
import '../../../main.dart';
import '../../../presentation/colors.dart';
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
              top: screenHeight * 0.07,
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
              bottom: screenHeight * 0.05,
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
                    Container(
                      width: screenWidth * 0.10,
                      height: screenWidth * 0.08,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[300],
                      ),
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        ReusableIconButton(
                          icon: Icons.search_rounded,
                          onPressed: () {
                            showSearchBottomSheet(context, buildCardItem);
                          },
                          screenWidth: screenWidth,
                          // Оставляем цвет иконки
                          borderRadius: 10,
                        ),
                        const SizedBox(width: 4),
                        // Кнопка крестика появляется, если есть выбранные элементы

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
                          screenWidth: MediaQuery.of(context).size.width,
                          // Цвет иконки
                          borderRadius: 10, // Закруглённые углы
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('item')
                      .where('userId',
                          isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const SizedBox();

                    final itemCount = snapshot.data!.docs.length;
                    final progress = (itemCount / 100).clamp(0.0, 1.0);
                    final isDarkTheme =
                        Theme.of(context).brightness == Brightness.dark;

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            height: 15,
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isDarkTheme
                                    ? AppColors.blueSand
                                    : Colors.blue, // Цвет линии в тёмной теме
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: progress *
                                  (MediaQuery.of(context).size.width * 0.85) -
                              10,
                          top: -25,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: isDarkTheme
                                      ? AppColors
                                          .blueSand // Цвет контейнера в тёмной теме
                                      : AppColors.violetSand,
                                  // Цвет в светлой теме
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                child: Text(
                                  '$itemCount%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                width: 23,
                                height: 23,
                                decoration: BoxDecoration(
                                  color: isDarkTheme
                                      ? AppColors
                                          .blueSand // Цвет точки в тёмной теме
                                      : Colors.blue,
                                  // Цвет точки в светлой теме
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
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
          SizedBox(
            height: screenHeight * 0.03,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              S.of(context).or,
              style: const TextStyle(fontSize: 24),
            ),
          ),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          SizedBox(
            height: 50,
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
                  children: typesWithColors.entries.map((entry) {
                    return _buildCategoryButton(
                        entry.key, entry.value, isDarkMode);
                  }).toList(),
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.01,
                vertical: screenHeight * 0.02,
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('item')
                    .where('userId',
                        isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No items found.'));
                  }

                  final items = snapshot.data!.docs.where((item) {
                    if (_selectedCategoryType == null) return true;
                    return item['type'] == _selectedCategoryType;
                  }).toList();

                  if (items.isEmpty) {
                    return const Center(
                        child: Text('No items found for selected category.'));
                  }

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final color = item['color'] as String? ?? '';
                      final imageUrl = item['imageUrl']
                          as String?; // Получаем URL изображения

                      return buildCardItem(
                        itemId: item.id,
                        title: item['title'],
                        description: item['description'],
                        type: item['type'],
                        color: color,
                        context: context,
                        imageUrl: imageUrl,
                        selectedCategoryType: _selectedCategoryType,
                        onStateUpdate: () {
                          setState(() {});
                        }, // Передаем URL изображения
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: ValueListenableBuilder<List<String>>(
        valueListenable: selectedItemsNotifier,
        builder: (context, selectedItems, child) {
          final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

          return selectedItems.isNotEmpty
              ? FloatingActionButton(
                  onPressed: () {
                    deleteSelectedItems(
                        context); // Удаление выделенных элементов
                  },
                  backgroundColor: Colors.redAccent, // Красный фон для удаления
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16), // Прямоугольная форма
                  ),
                  child: const Icon(Icons.delete),
                )
              : Container(
                  width: 60, // Фиксированная ширина
                  height: 60, // Фиксированная высота
                  decoration: isDarkTheme
                      ? BoxDecoration(
                          gradient: AppColors
                              .blueGradient, // Градиент для темной темы
                          borderRadius:
                              BorderRadius.circular(16), // Закругленные углы
                        )
                      : null,
                  child: FloatingActionButton(
                    onPressed: () {
                      showAddItemBottomSheet(context); // Добавление элемента
                    },
                    backgroundColor: isDarkTheme
                        ? Colors.transparent // Прозрачный фон для градиента
                        : Colors.blueAccent,
                    // Синий цвет для светлой темы
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(16), // Прямоугольная форма
                    ),
                    elevation: 0,
                    child: const Icon(Icons.add), // Убираем тень для градиента
                  ),
                );
        },
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
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              type,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
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
    return null; // Возвращаем null в случае ошибки
  }
}

Future<void> deleteSelectedItems(BuildContext context) async {
  try {
    for (String itemId in selectedItemsNotifier.value) {
      await FirebaseFirestore.instance
          .collection('item')
          .doc(itemId)
          .delete(); // Удаление элемента из Firebase
    }
    // Очищаем список выделенных элементов
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
