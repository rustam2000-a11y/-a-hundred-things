import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../presentation/colors.dart';
import 'bottom_container_button.dart';

// Глобальный словарь для хранения цветов по типу
final Map<String, String> typeColorsCache = {};

// Функция для генерации случайного цвета в формате HEX
String getRandomColor() {
  final random = Random();
  return '#${random.nextInt(0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
}

// Функция для получения цвета из HEX
Color? getColorFromHex(String? hexColor) {
  if (hexColor == null || !hexColor.startsWith('#')) return null;
  try {
    return Color(int.parse(hexColor.replaceFirst('#', '0xff')));
  } catch (e) {
    return null; // Возвращаем null в случае ошибки
  }
}

void showAddItemBottomSheet(BuildContext context) {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  String? _imageUrl;

  Future<void> _pickImage(BuildContext context, StateSetter setState) async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка выбора изображения: $e')),
      );
    }
  }

  Future<String> _uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('item_images/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = await storageRef.putFile(image);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Ошибка загрузки изображения: $e');
    }
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      final screenHeight = MediaQuery.of(context).size.height;
      final screenWidth = MediaQuery.of(context).size.width;
      final isDarkMode = Theme.of(context).brightness == Brightness.dark;

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                height: screenHeight,
                color: isDarkMode ? AppColors.blackSand : Colors.white,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GestureDetector(
                      onTap: () => _pickImage(context, setState),
                      child: Container(
                        height: screenHeight * 0.6,
                        width: double.infinity,
                        color: isDarkMode
                            ? AppColors.blackSand
                            : null, // Цвета для светлой темы не задаем, так как используется градиент
                        decoration: isDarkMode
                            ? null // Градиент не используется в темной теме
                            : BoxDecoration(
                          gradient: AppColors.greyWhite, // Устанавливаем градиент для светлой темы
                        ),
                        child: Center(
                          child: _selectedImage != null
                              ? Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          )
                              : Container(
                            width: screenWidth * 0.5,
                            height: screenWidth * 0.5,
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? AppColors.violetSand
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.add,
                              color: isDarkMode
                                  ? Colors.white
                                  : Colors.white,
                              size: screenWidth * 0.15,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: screenHeight * 0.05,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: TextField(
                          controller: _typeController,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            hintText: 'Тип',
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: screenHeight * 0.55,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: screenHeight * 0.50,
                        padding: EdgeInsets.all(screenWidth * 0.05),
                        decoration: BoxDecoration(
                          gradient: isDarkMode
                              ? AppColors.darkBlueGradient
                              : null,
                          color: isDarkMode
                              ? null
                              : AppColors.silverColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            TextField(
                              controller: _titleController,
                              decoration: const InputDecoration(
                                labelText: 'Название предмета',
                                border: InputBorder.none,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            TextField(
                              controller: _descriptionController,
                              decoration: const InputDecoration(
                                labelText: 'Описание предмета',
                                border: InputBorder.none,
                              ),
                              style: TextStyle(fontSize: screenWidth * 0.045),
                              maxLines: 4,
                              minLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? AppColors.blackSand
                              : AppColors.whiteColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 26),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AddButton(
                              onPressed: () async {
                                if (_titleController.text.isNotEmpty &&
                                    _descriptionController.text.isNotEmpty &&
                                    _typeController.text.isNotEmpty) {
                                  try {
                                    // Если изображение выбрано, загрузим его
                                    if (_selectedImage != null) {
                                      _imageUrl =
                                      await _uploadImage(_selectedImage!);
                                    }

                                    // Проверка на наличие цвета для типа
                                    final type = _typeController.text.trim();
                                    if (!typeColorsCache.containsKey(type)) {
                                      typeColorsCache[type] = getRandomColor(); // Генерация нового цвета
                                    }
                                    final randomColor = typeColorsCache[type]!;
                                    final items = await FirebaseFirestore.instance.collection('item').get();
                                    for (var item in items.docs) {
                                      await item.reference.update({'quantity': 1});
                                    }
                                    // Добавление элемента в Firestore
                                    await FirebaseFirestore.instance.collection('item').add({
                                      'title': _titleController.text,
                                      'description': _descriptionController.text,
                                      'type': type,
                                      'userId': FirebaseAuth.instance.currentUser?.uid,
                                      'color': randomColor, // Основной цвет
                                      'typeColor': randomColor, // Цвет для типа
                                      'timestamp': Timestamp.now(),
                                      'imageUrl': _imageUrl,
                                      'quantity': 1, // Инициализируем с количеством 1

                                    });

                                    Navigator.pop(context);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error: $e')),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Please fill all fields')),
                                  );
                                }
                              },
                            ),

                            const SizedBox(width: 20),
                            CancelButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
