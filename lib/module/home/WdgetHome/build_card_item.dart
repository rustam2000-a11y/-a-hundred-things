import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:one_hundred_things/module/home/WdgetHome/show_modal_buttom_sheet.dart';
import '../../../generated/l10n.dart';
import '../../../presentation/colors.dart';
import 'edit_item_bottom_sheet.dart';
import 'home_widget.dart';

List<String> selectedItems = [];
final ValueNotifier<List<String>> selectedItemsNotifier = ValueNotifier([]);
String? selectedCategoryType;
bool isSelectionMode = false; // Переменная для режима выбора

Widget buildCardItem({
  required BuildContext context,
  required String itemId,
  required String title,
  required String description,
  required String type,
  required String color,
  String? imageUrl, // Поле для URL изображения
}) {
  return ValueListenableBuilder<List<String>>(
    valueListenable: selectedItemsNotifier,
    builder: (context, selectedItems, child) {
      final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
      final isSelected = selectedItems.contains(itemId);

      final backgroundColor = isDarkTheme
          ? (isSelected
          ? AppColors.darkBlueGradient.colors.first
          : AppColors.blackSand)
          : getColorFromHex(color) ?? AppColors.silverColor;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: GestureDetector(
          onTap: () {
            if (isSelectionMode) {
              _toggleSelection(itemId);
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
            if (!isSelectionMode) {
              isSelectionMode = true;
              _toggleSelection(itemId);
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
              boxShadow: isDarkTheme
                  ? [
                const BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0, 1),
                  blurRadius: 0,
                  spreadRadius: 0,
                ),
              ]
                  : [],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImage(imageUrl, isDarkTheme),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildItemDetails(
                      context: context,
                      title: title,
                      description: description,
                      type: type,
                      isDarkTheme: isDarkTheme,
                      isSelected: isSelected,
                      itemId: itemId,
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

Widget _buildImage(String? imageUrl, bool isDarkTheme) {
  return Container(
    width: 100,
    height: 100,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: imageUrl == null
          ? (isDarkTheme ? AppColors.blackSand : Colors.grey[300])
          : null,
      image: imageUrl != null
          ? DecorationImage(
        image: NetworkImage(imageUrl),
        fit: BoxFit.cover,
      )
          : null,
    ),
    child: imageUrl == null
        ? Center(
      child: Icon(Icons.image, size: 40, color: Colors.grey[600]),
    )
        : null,
  );
}

Widget _buildItemDetails({
  required BuildContext context,
  required String title,
  required String description,
  required String type,
  required bool isDarkTheme,
  required bool isSelected,
  required String itemId,
}) {
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
          _buildActionIcons(
            context: context,
            isDarkTheme: isDarkTheme,
            isSelected: isSelected,
            itemId: itemId,
            title: title,
            description: description,
            type: type,
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
      Text(
        type,
        style: TextStyle(
          color: isDarkTheme ? Colors.white : Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}

Widget _buildActionIcons({
  required BuildContext context,
  required bool isDarkTheme,
  required bool isSelected,
  required String itemId,
  required String title,
  required String description,
  required String type,
}) {
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
          color: isDarkTheme ? Colors.white : Colors.white,
        ),
        onPressed: () {
          showEditItemBottomSheet(
            context,
            itemId: itemId,
            initialTitle: title,
            initialDescription: description,
            initialType: type,
          );
        },
      ),
      IconButton(
        icon: Icon(
          Icons.close,
          color: isDarkTheme ? Colors.white : Colors.white,
        ),
        onPressed: () async {
          try {
            await FirebaseFirestore.instance
                .collection('item')
                .doc(itemId)
                .delete();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Item deleted successfully')),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $e')),
            );
          }
        },
      ),
    ],
  );
}

void _toggleSelection(String itemId) {
  final currentItems = List<String>.from(selectedItemsNotifier.value);
  if (currentItems.contains(itemId)) {
    currentItems.remove(itemId);
  } else {
    currentItems.add(itemId);
  }
  selectedItemsNotifier.value = currentItems;

  // Если список выбранных элементов пуст, отключаем режим выбора
  if (currentItems.isEmpty) {
    isSelectionMode = false;
  }
}
