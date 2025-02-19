import 'package:flutter/material.dart';
import 'edit_item_bottom_sheet.dart';

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
