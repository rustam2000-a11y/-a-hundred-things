import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../model/things_model.dart';
import '../../../presentation/colors.dart';
import '../../../repository/things_repository.dart';
import 'things_card_item.dart';

void showSearchBottomSheet(BuildContext context, ThingsRepositoryI repository) {
  final TextEditingController searchController = TextEditingController();
  final StreamController<String> _searchStreamController = StreamController<String>();

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

      return FractionallySizedBox(
        heightFactor: 0.8,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              gradient: isDarkMode ? AppColors.darkBlueGradient : null,
              color: !isDarkMode ? AppColors.silverColor : null,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Поисковая строка
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
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
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
                              onPressed: searchController.clear,
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
                const SizedBox(height: 20),

                // Список вещей
                Expanded(
                  child: StreamBuilder<String>(
                    stream: _searchStreamController.stream,
                    builder: (context, searchSnapshot) {
                      final searchQuery = searchSnapshot.data ?? '';

                      return StreamBuilder<List<ThingsModel>>(
                        stream: repository.searchThingsByTitle(searchQuery),
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
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text('No items match your search.'));
                          }

                          final items = snapshot.data!;

                          return ListView.builder(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 8),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return ThingsCardWidget(
                                itemId: item.id,
                                title: item.title,
                                description: item.description,
                                type: item.type,
                                color: item.color,
                                imageUrl: item.imageUrl,
                                onStateUpdate: () {},
                                quantity: item.quantity,
                              );
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
        ),
      );
    },
  ).whenComplete(_searchStreamController.close);
}

