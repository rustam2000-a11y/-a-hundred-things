import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'action_icons.dart';
import 'counter_controls.dart';
import 'edit_item_bottom_sheet.dart';
import 'item_image.dart';
import 'show_add_item_bottom_sheet.dart';
import 'show_modal_buttom_sheet.dart';

final Map<String, int> itemCounts = {};
final Map<String, String> typeColors = {};

Color getColorForType(String type) {
  if (!typeColorsCache.containsKey(type)) {
    typeColorsCache[type] = getRandomColor();
  }
  return getColorFromHex(typeColorsCache[type]) ?? Colors.grey;
}

class ThingsCardWidget extends StatelessWidget {
  const ThingsCardWidget({
    super.key,
    required this.itemId,
    required this.title,
    required this.description,
    required this.type,
    required this.color,
    required this.onStateUpdate,
    this.onDeleteItem,
    this.imageUrl,
    this.selectedCategoryType,
    required this.quantity,
    this.selectedItemsNotifier,
  });

  final String itemId;
  final String title;
  final String description;
  final String type;
  final String color;
  final VoidCallback onStateUpdate;
  final VoidCallback? onDeleteItem;
  final String? imageUrl;
  final String? selectedCategoryType;
  final int quantity;
  final ValueNotifier<List<String>>? selectedItemsNotifier;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<List<String>>(
      valueListenable: selectedItemsNotifier ?? ValueNotifier([]),
      builder: (context, selectedItems, child) {
        final isSelected = selectedItems.contains(itemId);
        final backgroundColor = isDarkTheme
            ? (isSelected ? Colors.blueGrey : Colors.black54)
            : getColorForType(type);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: GestureDetector(
            onTap: () {
              if (selectedItemsNotifier != null && selectedItems.isNotEmpty) {
                _toggleSelection(selectedItemsNotifier!, itemId);
              } else {
                showItemDetailsBottomSheet(
                  context: context,
                  title: title,
                  description: description,
                  type: type,
                  itemId: itemId,
                  imageUrl: imageUrl,
                );
              }
            },
            onLongPress: () {
              if (selectedItemsNotifier != null) {
                _toggleSelection(selectedItemsNotifier!, itemId);
              }
            },
            child: AnimatedContainer(

              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected ? Colors.blueAccent : Colors.transparent,
                  width: isSelected ? 2 : 0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(0, 1),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ItemImage(
                              imageUrl: imageUrl,
                              itemId: itemId,
                              isSelected: isSelected,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          title,
                                          style: TextStyle(
                                            color: isDarkTheme ? Colors.white : Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      ActionIcons(
                                        isDarkTheme: isDarkTheme,
                                        isSelected: isSelected,
                                        itemId: itemId,
                                        title: title,
                                        description: description,
                                        type: type,
                                        imageUrl: imageUrl,
                                        onDeleteItem: onDeleteItem,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    description.length > 20
                                        ? '${description.substring(0, 20)}...'
                                        : description,
                                    style: TextStyle(
                                      color: isDarkTheme ? Colors.white : Colors.black,
                                    ),
                                  ),

                                ],
                              ),
                              // ItemDetails(
                              //   title: title,
                              //   description: description,
                              //   type: type,
                              //   isDarkTheme: isDarkTheme,
                              //   isSelected: isSelected,
                              //   itemId: itemId,
                              //   imageUrl: imageUrl,
                              //   onDeleteItem: onDeleteItem,
                              // ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (selectedCategoryType != null ||
                        selectedCategoryType == type)
                      Positioned(
                        right: 8,
                        bottom: 8,
                        child: CounterControls(
                          itemId: itemId,
                          itemType: type,
                          onStateUpdate: onStateUpdate,
                          selectedCategoryType: selectedCategoryType,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _toggleSelection(ValueNotifier<List<String>> notifier, String itemId) {
    final currentItems = List<String>.from(notifier.value);
    if (currentItems.contains(itemId)) {
      currentItems.remove(itemId);
    } else {
      currentItems.add(itemId);
    }
    notifier.value = currentItems;
  }
}








