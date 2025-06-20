import 'package:flutter/material.dart';

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
  final List<String>? imageUrl;
  final VoidCallback? onDeleteItem;

  @override
  Widget build(BuildContext context) {
    if (isSelected) {
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
        ),
        child: const Icon(
          Icons.check,
          color: Colors.white,
          size: 18,
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(
            Icons.edit,
            color: isDarkTheme ? Colors.white : Colors.black,
          ),
          onPressed: () {},
        ),
        IconButton(
          padding: EdgeInsets.zero,
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
