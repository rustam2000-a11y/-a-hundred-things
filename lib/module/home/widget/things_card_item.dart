import 'package:flutter/material.dart';
import '../../things/new_things/create_new_thing_screen.dart';
import 'card_widget/new_card_widget.dart';

final Map<String, int> itemCounts = {};
final Map<String, String> typeColors = {};

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
    required this.allTypes,
    required this.location,
    required this.weight,
    required this.colorText,
    required this.importance,
    required this.favorites,
  });

  final String itemId;
  final String title;
  final String description;
  final String type;
  final VoidCallback onStateUpdate;
  final VoidCallback? onDeleteItem;
  final List<String>? imageUrl;
  final String? selectedCategoryType;
  final int quantity;
  final ValueNotifier<List<String>>? selectedItemsNotifier;
  final List<String> allTypes;
  final String location;
  final double weight;
  final String colorText;
  final int importance;
  final bool favorites;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<List<String>>(
      valueListenable: selectedItemsNotifier ?? ValueNotifier([]),
      builder: (context, selectedItems, child) {
        final isSelected = selectedItems.contains(itemId);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: GestureDetector(
            onTap: () async {
              if (selectedItemsNotifier != null && selectedItems.isNotEmpty) {
                _toggleSelection(selectedItemsNotifier!, itemId);
              } else {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute<bool>(
                    builder: (context) => CreateNewThingScreen(
                      allTypes: allTypes,
                      isReadOnly: true,
                      existingThing: {
                        'id': itemId,
                        'title': title,
                        'description': description,
                        'type': type,
                        'imageUrls': imageUrl ?? [],
                        'quantity': quantity,
                        'location': location,
                        'weight': weight,
                        'colorText': colorText,
                        'importance': importance,
                        'favorites': favorites,
                      },
                    ),
                  ),
                );

                if (result == true) {
                  onStateUpdate();
                }
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
