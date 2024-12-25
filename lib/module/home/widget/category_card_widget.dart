import 'package:flutter/material.dart';

import '../../../core/utils/presentation.utils.dart';
import '../../../presentation/colors.dart';

class CategoryCardWidget extends StatelessWidget {
  const CategoryCardWidget({
    super.key,
    required this.selectedCategoryType,
    required this.onChangeCategory,
    required this.onDeleteThings,
    required this.isDarkMode,
    required this.color,
    required this.type,
  });

  final String? selectedCategoryType;
  final void Function(String? category) onChangeCategory;
  final VoidCallback onDeleteThings;
  final bool isDarkMode;
  final String color;
  final String type;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = PresentationUtils.getColorFromHex(color) ?? AppColors.silverColor;
    final isSelected = selectedCategoryType == type;
    return GestureDetector(
      onTap: () {
        onChangeCategory(type);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: isDarkMode ? AppColors.whiteToBlackGradient : null,
            color: !isDarkMode ? backgroundColor : null,
            borderRadius: BorderRadius.circular(10),
            border: isSelected
                ? Border.all(color: AppColors.silverColor, width: 2)
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                type,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onDeleteThings,
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
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