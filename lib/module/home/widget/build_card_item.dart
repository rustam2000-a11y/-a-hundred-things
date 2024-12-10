import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../presentation/colors.dart';
import 'edit_item_bottom_sheet.dart';
import 'home_widget.dart' as home;
import 'show_add_item_bottom_sheet.dart'; // Импорт функции showAddItemBottomSheet
import 'show_modal_buttom_sheet.dart';

List<String> selectedItems = [];
final ValueNotifier<List<String>> selectedItemsNotifier = ValueNotifier([]);
bool isSelectionMode = false; // Переменная для режима выбора

final Map<String, int> itemCounts = {};

/// Глобальный словарь для сохранения цветов по типу
final Map<String, String> typeColors =
{}; // Словарь для хранения цветов по типу

/// Функция для получения цвета для типа из глобального словаря
Color getColorForType(String type) {
  if (!typeColorsCache.containsKey(type)) {
    // Если типа нет в кэше, генерируем цвет и сохраняем
    typeColorsCache[type] = getRandomColor();
  }
  return getColorFromHex(typeColorsCache[type]) ?? Colors.grey;
}

Widget buildCardItem({
  required BuildContext context,
  required String itemId,
  required String title,
  required String description,
  required String type,
  required String color,
  required VoidCallback onStateUpdate,
  String? imageUrl,
  String? selectedCategoryType,
  required int quantity,
}) {
  return ValueListenableBuilder<List<String>>(
    valueListenable: selectedItemsNotifier,
    builder: (context, selectedItems, child) {
      final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
      final isSelected = selectedItems.contains(itemId);

      final backgroundColor = isDarkTheme
          ? (isSelected ? Colors.blueGrey : Colors.black54)
          : getColorForType(type);

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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // Цвет тени с прозрачностью
                  offset: const Offset(0, 1), // Смещение по X и Y
                  blurRadius: 5, // Радиус размытия
                  spreadRadius: 1, // Радиус распространения
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
                              imageUrl: imageUrl,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (selectedCategoryType != null || selectedCategoryType == type)
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: _buildCounterControls(
                        context,
                        itemId,
                        type,
                        onStateUpdate,
                        selectedCategoryType,
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
    height: 90,
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
  String? imageUrl,
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
            imageUrl: imageUrl,
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
      // Удаляем отображение типа
      // Text(
      //   type,
      //   style: TextStyle(
      //     color: isDarkTheme ? Colors.white : Colors.black,
      //     fontSize: 14,
      //     fontWeight: FontWeight.bold,
      //   ),
      // ),
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
  String? imageUrl,
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
            initialType: type, imageUrl: imageUrl ,
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

  if (currentItems.isEmpty) {
    isSelectionMode = false;
  }
}

Widget _buildCounterControls(BuildContext context, String itemId,
    String itemType, VoidCallback onStateUpdate, String? selectedCategoryType) {
  return StreamBuilder<DocumentSnapshot>(
    stream: FirebaseFirestore.instance.collection('item').doc(itemId).snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData || snapshot.data == null || snapshot.data!.data() == null) {
        return const SizedBox.shrink(); // Возвращаем пустой виджет, пока данные загружаются
      }

      // Приводим данные к Map<String, dynamic>
      final data = snapshot.data!.data() as Map<String, dynamic>;
      final quantity = data['quantity'] ?? 1;

      return Row(
        children: [
          IconButton(
            icon: const Icon(Icons.remove, color: Colors.white),
            onPressed: () {
              _decrementItem(itemId, itemType, onStateUpdate, selectedCategoryType);
            },
          ),
          Text(
            '$quantity',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              _incrementItem(itemId, itemType, onStateUpdate, selectedCategoryType);
            },
          ),
        ],
      );
    },
  );
}



Future<void> _incrementItem(String itemId, String itemType, VoidCallback onStateUpdate,
    String? selectedCategoryType) async {
  if (selectedCategoryType == null || selectedCategoryType == itemType) {
    // Увеличиваем локальный счетчик
    itemCounts[itemId] = (itemCounts[itemId] ?? 1) + 1;
    onStateUpdate();

    // Обновляем количество в Firebase
    final itemRef = FirebaseFirestore.instance.collection('item').doc(itemId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(itemRef);

      if (snapshot.exists) {
        final currentQuantity = snapshot.data()?['quantity'] ?? 1;
        transaction.update(itemRef, {'quantity': currentQuantity + 1});
      }
    });
  }
}



Future<void> _decrementItem(String itemId, String itemType, VoidCallback onStateUpdate,
    String? selectedCategoryType) async {
  if (selectedCategoryType == null || selectedCategoryType == itemType) {
    // Получаем текущий счетчик из локального хранилища
    final currentCount = itemCounts[itemId] ?? 1;

    if (currentCount > 1) {
      // Уменьшаем локальный счетчик
      itemCounts[itemId] = currentCount - 1;
      onStateUpdate();

      // Обновляем количество в Firebase
      final itemRef = FirebaseFirestore.instance.collection('item').doc(itemId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(itemRef);

        if (snapshot.exists) {
          final currentQuantity = snapshot.data()?['quantity'] as int? ?? 1;
          if (currentQuantity > 1) {
            transaction.update(itemRef, {'quantity': currentQuantity - 1});
          } else {
            // Если количество становится 1, удаляем элемент из базы данных
            transaction.delete(itemRef);
          }
        }
      });
    }
  }
}