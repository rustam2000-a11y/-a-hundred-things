import 'package:flutter/material.dart';
import 'action_icons.dart';


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
