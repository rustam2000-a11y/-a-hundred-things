import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'edit_item_bottom_sheet.dart';
import 'show_add_item_bottom_sheet.dart'; // Импорт функции showAddItemBottomSheet
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
                                  const SizedBox(height: 8),
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

class ItemImage extends StatelessWidget {

  const ItemImage({
    Key? key,
    required this.imageUrl,
    required this.itemId,
    required this.isSelected,
  }) : super(key: key);
  final String? imageUrl;
  final String itemId;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('item').doc(itemId).snapshots(),
          builder: (context, snapshot) {
            String? firstImageUrl;

            if (snapshot.hasData && snapshot.data != null) {
              final data = snapshot.data!.data() as Map<String, dynamic>?;
              if (data != null && data['imageUrls'] is List<dynamic>) {
                final imageUrls = data['imageUrls'] as List<dynamic>;
                if (imageUrls.isNotEmpty) {
                  firstImageUrl = imageUrls.first as String?;
                }
              }
            }

            return Container(
              width: 100,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: firstImageUrl == null
                    ? Colors.grey[300]
                    : null,
                image: firstImageUrl != null
                    ? DecorationImage(
                  image: NetworkImage(firstImageUrl),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: firstImageUrl == null
                  ? Center(
                child: Icon(Icons.image, size: 40, color: Colors.grey[600]),
              )
                  : null,
            );
          },
        ),
        if (isSelected)
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
      ],
    );
  }
}

class ItemDetails extends StatelessWidget {

  const ItemDetails({
    Key? key,
    required this.title,
    required this.description,
    required this.type,
    required this.isDarkTheme,
    required this.isSelected,
    this.onDeleteItem,
    required this.itemId,
    this.imageUrl,
  }) : super(key: key);

  final String title;
  final String description;
  final String type;
  final bool isDarkTheme;
  final bool isSelected;
  final VoidCallback? onDeleteItem;
  final String itemId;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
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
        const SizedBox(height: 8),
      ],
    );
  }
}

class ActionIcons extends StatelessWidget {

  const ActionIcons({
    Key? key,
    required this.isDarkTheme,
    required this.isSelected,
    required this.itemId,
    required this.title,
    required this.description,
    required this.type,
    this.imageUrl,
    this.onDeleteItem,
  }) : super(key: key);
  final bool isDarkTheme;
  final bool isSelected;
  final String itemId;
  final String title;
  final String description;
  final String type;
  final String? imageUrl;
  final VoidCallback? onDeleteItem;

  @override
  Widget build(BuildContext context) {
    if (isSelected) {
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Icon(
          Icons.check,
          color: Colors.white,
          size: 18,
        ),
      );
    }

    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.edit,
            color: isDarkTheme ? Colors.white : Colors.black,
          ),
          onPressed: () {
            showEditItemBottomSheet(
              context,
              itemId: itemId,
              initialTitle: title,
              initialDescription: description,
              initialType: type,
              imageUrl: imageUrl,
            );
          },
        ),
        IconButton(
          icon: Icon(
            Icons.close,
            color: isDarkTheme ? Colors.white : Colors.black,
          ),
          onPressed: onDeleteItem,
        ),
      ],
    );
  }
}

class CounterControls extends StatelessWidget {

  const CounterControls({
    Key? key,
    required this.itemId,
    required this.itemType,
    required this.onStateUpdate,
    this.selectedCategoryType,
  }) : super(key: key);
  final String itemId;
  final String itemType;
  final VoidCallback onStateUpdate;
  final String? selectedCategoryType;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('item').doc(itemId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null || snapshot.data!.data() == null) {
          return const SizedBox.shrink();
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final quantity = data['quantity'] ?? 1;

        return Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove, color: Colors.white),
              onPressed: () => _updateQuantity(itemId, itemType, -1, onStateUpdate, selectedCategoryType),
            ),
            Text(
              '$quantity',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () => _updateQuantity(itemId, itemType, 1, onStateUpdate, selectedCategoryType),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateQuantity(String itemId, String itemType, int change, VoidCallback onStateUpdate, String? selectedCategoryType) async {
    if (selectedCategoryType == null || selectedCategoryType == itemType) {
      final itemRef = FirebaseFirestore.instance.collection('item').doc(itemId);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(itemRef);
        if (snapshot.exists) {
          final currentQuantity = snapshot.data()?['quantity'] ?? 1;
          final newQuantity = currentQuantity + change;
          if (newQuantity > 0) {
            transaction.update(itemRef, {'quantity': newQuantity});
          } else {
            transaction.delete(itemRef);
          }
        }
      });
      onStateUpdate();
    }
  }
}
