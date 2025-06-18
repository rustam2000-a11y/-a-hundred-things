import 'package:flutter/material.dart';

class CategoryCardWidget extends StatelessWidget {
  const CategoryCardWidget({
    super.key,
    required this.selectedCategoryType,
    required this.onChangeCategory,
    required this.onDeleteThings,
    required this.type,
  });

  final String? selectedCategoryType;
  final void Function(String? category) onChangeCategory;
  final VoidCallback onDeleteThings;
  final String type;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedCategoryType == type;
    final Color backgroundColor = isSelected ? Colors.black : Colors.transparent;
    const Color borderColor = Colors.black;
    final Color contentColor = isSelected ? Colors.white : Colors.black;

    return GestureDetector(
      onTap: () {
        onChangeCategory(type);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(width: 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                type,
                style: TextStyle(
                  color: contentColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onDeleteThings,
                child: Icon(
                  Icons.close,
                  color: contentColor,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
