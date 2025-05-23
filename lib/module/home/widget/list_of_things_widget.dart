import 'package:flutter/material.dart';
import 'things_card_item.dart';

class ThingsListWidget extends StatelessWidget {

  const ThingsListWidget({
    super.key,
    required this.things,
    required this.selectedCategoryType,
    required this.selectedItemsNotifier,
    required this.onDeleteItem,
    required this.onStateUpdate,
  });
  final List<dynamic> things;
  final String? selectedCategoryType;
  final ValueNotifier<List<String>> selectedItemsNotifier;
  final void Function(String uid) onDeleteItem;
  final VoidCallback onStateUpdate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: things.length,
        itemBuilder: (context, index) {
          final item = things[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ThingsCardWidget(
              itemId: item.id,
              title: item.title,
              description: item.description,
              type: item.type,
              imageUrl: item.imageUrl,
              selectedCategoryType: selectedCategoryType,
              onStateUpdate: onStateUpdate,
              quantity: item.quantity,
              onDeleteItem: () => onDeleteItem(item.id),
              selectedItemsNotifier: selectedItemsNotifier,
            ),
          );
        },
      ),
    );
  }
}