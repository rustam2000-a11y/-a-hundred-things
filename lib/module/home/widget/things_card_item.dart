import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'action_icons.dart';
import 'counter_controls.dart';
import 'edit_item_bottom_sheet.dart';
import 'item_image.dart';
import 'new_card_widget.dart';
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
            child: ThingCardContainer(
        isSelected: isSelected,
        isDarkTheme: isDarkTheme,
        title: title,
        description: description,
        imageUrl: imageUrl,
        itemId: itemId,
        type: type,
        onDeleteItem: onDeleteItem,
        selectedCategoryType: selectedCategoryType,
        onStateUpdate: onStateUpdate,
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








