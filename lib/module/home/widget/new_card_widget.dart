import 'package:flutter/material.dart';
import 'action_icons.dart';
import 'counter_controls.dart';
import 'item_image.dart';

class ThingCardContainer extends StatelessWidget {
  const ThingCardContainer({
    super.key,
    required this.isSelected,
    required this.isDarkTheme,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.itemId,
    required this.type,
    required this.onDeleteItem,
    required this.selectedCategoryType,
    required this.onStateUpdate,
  });

  final bool isSelected;
  final bool isDarkTheme;
  final String title;
  final String description;
  final String? imageUrl;
  final String itemId;
  final String type;
  final VoidCallback? onDeleteItem;
  final String? selectedCategoryType;
  final VoidCallback onStateUpdate;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isSelected ? Colors.black : Colors.black,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ItemImage(
                  imageUrl: imageUrl,
                  itemId: itemId,
                  isSelected: isSelected,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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

                      const SizedBox(height: 18),
                      Text(
                        description.length > 10
                            ? '${description.substring(0, 18)}...'
                            : description,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkTheme ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (selectedCategoryType != null || selectedCategoryType == type)
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CounterControls(
                    itemId: itemId,
                    itemType: type,
                    onStateUpdate: onStateUpdate,
                    selectedCategoryType: selectedCategoryType,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
