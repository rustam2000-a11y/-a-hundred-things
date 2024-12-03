import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../presentation/colors.dart';
import 'home_widget.dart';

void showSearchBottomSheet(BuildContext context, Function buildCardItem) {
  final StreamController<String> _searchStreamController =
      StreamController<String>();
  final TextEditingController controller = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  String _searchQuery = '';

  searchController.addListener(() {
    _searchStreamController.add(searchController.text.toLowerCase());
  });

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      final screenHeight = MediaQuery.of(context).size.height;
      final screenWidth = MediaQuery.of(context).size.width;
      final isDarkMode = Theme.of(context).brightness == Brightness.dark;

      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.only(top: 20),
          height: screenHeight * 0.8,
          decoration: BoxDecoration(
            gradient: isDarkMode
                ? AppColors
                    .darkBlueGradient // Устанавливаем градиент для темной темы
                : null, // Без градиента для светлой темы
            color: !isDarkMode
                ? AppColors.silverColor // Устанавливаем цвет для светлой темы
                : null, // Цвет не нужен в темной теме
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.09),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 55,
                      margin: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: AppColors.violetSand,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back,
                            color: isDarkMode ? Colors.white : Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    // SizedBox(width: 20),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        style: TextStyle(
                          color: isDarkMode
                              ? Colors.white
                              : Colors.black, // Текстовый цвет
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search by title...',
                          hintStyle: TextStyle(
                            color: isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[700],
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[700],
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear,
                                color: isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.grey[700]),
                            onPressed: () {
                              searchController.clear(); // Очистка текста
                            },
                          ),
                          filled: true,
                          fillColor: isDarkMode
                              ? Colors.grey[900]
                              : AppColors.violetSand,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: StreamBuilder<String>(
                  stream: _searchStreamController.stream,
                  builder: (context, searchSnapshot) {
                    final searchQuery = searchSnapshot.data ?? '';

                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('item')
                          .where('userId',
                              isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(child: Text('No items found.'));
                        }

                        final items = snapshot.data!.docs.where((item) {
                          final title = item['title'] as String;
                          return title.toLowerCase().contains(searchQuery);
                        }).toList();

                        if (items.isEmpty) {
                          return Center(
                              child: Text('No items match your search.'));
                        }

                        return ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            final color = item['color'] as String? ?? '';
                            final imageUrl = item['imageUrl'] as String?;
                            return buildCardItem(
                                itemId: item.id,
                                title: item['title'],
                                description: item['description'],
                                type: item['type'],
                                color: color,
                                context: context,
                                imageUrl: imageUrl);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  ).whenComplete(() {
    _searchStreamController.close(); // Закрываем поток при закрытии BottomSheet
  });
}
