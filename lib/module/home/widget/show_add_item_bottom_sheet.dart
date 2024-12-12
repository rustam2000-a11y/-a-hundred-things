import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cropperx/cropperx.dart';
import '../../../presentation/colors.dart';
import 'bottom_container_button.dart';


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
  List<File> _selectedImages = [];
  List<String> _imageUrls = [];

  Future<void> _pickAndCropImage(BuildContext context, StateSetter setState) async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final _cropperKey = GlobalKey(debugLabel: 'cropperKey'); // Определяем ключ
        File imageFile = File(pickedFile.path);

        // Открываем диалог для обрезки
        await showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Column(
                children: [
                  Expanded(
                    child: Cropper(
                      cropperKey: _cropperKey, // Используем ключ
                      image: Image.file(imageFile), // Загружаем выбранное изображение
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      // Получаем данные обрезанного изображения
                      final imageBytes = await Cropper.crop(
                        cropperKey: _cropperKey, // Указываем ключ
                      );

                      if (imageBytes != null) {
                        final tempDir = Directory.systemTemp;
                        final tempFile = File(
                            '${tempDir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.png');
                        tempFile.writeAsBytesSync(imageBytes);
                        setState(() {
                          _selectedImages.add(tempFile); // Добавляем обрезанное изображение
                        });
                      }
                      Navigator.pop(context); // Закрываем диалог
                    },
                    child: const Text('Обрезать'),
                  ),
                ],
              ),
            );
          },
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка обрезки изображения: $e')),
      );
    }
  }




  Future<List<String>> _uploadImages(List<File> images) async {
    List<String> urls = [];
    for (var image in images) {
      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('item_images/${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}');
        final uploadTask = await storageRef.putFile(image);
        final downloadUrl = await uploadTask.ref.getDownloadURL();
        urls.add(downloadUrl);
      } catch (e) {
        throw Exception('Ошибка загрузки изображения: $e');
      }
    }
    return urls;
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      final screenHeight = MediaQuery.of(context).size.height;
      final screenWidth = MediaQuery.of(context).size.width;
      final isDarkMode = Theme.of(context).brightness == Brightness.dark;

      return SafeArea(
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Container(
                height: screenHeight,
                color: isDarkMode ? AppColors.blackSand : Colors.white,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Выбор изображений
                    // Обновляем GestureDetector для выбора и обрезки изображений
                    GestureDetector(
                      onTap: () async {
                        await _pickAndCropImage(context, setState);
                      },
                      child: Container(
                        height: screenHeight * 0.6,
                        width: double.infinity,
                        color: isDarkMode ? AppColors.blackSand : null,
                        decoration: isDarkMode
                            ? null
                            : const BoxDecoration(
                          gradient: AppColors.greyWhite,
                        ),
                        child: Center(
                          child: _selectedImages.isNotEmpty
                              ? PageView.builder(
                            itemCount: _selectedImages.length,
                            itemBuilder: (context, index) {
                              return Image.file(
                                _selectedImages[index],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              );
                            },
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
                              color: Colors.white,
                              size: screenWidth * 0.15,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Тип по центру
                    Positioned(
                      top: screenHeight * 0.05,
                      left: 0,
                      right: 0,
                      child: Stack(
                        alignment: Alignment.center, // Центрируем содержимое по горизонтали
                        children: [
                          // Текст "Тип" строго по центру
                          TextField(
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
                          // Иконка с левой стороны, но не вплотную к границе
                          Positioned(
                            left: screenWidth * 0.05, // Отступ от левой границы
                            child: IconButton(
                              icon: Icon(
                                Icons.keyboard_arrow_down_outlined,
                                color: isDarkMode ? Colors.white : Colors.white,
                                size: screenWidth * 0.1,
                              ),
                              onPressed: () {
                                Navigator.pop(context); // Закрытие BottomSheet
                              },
                            ),

                          ),
                        ],
                      ),
                    ),
                    // Поля ввода
                    Positioned(
                      top: screenHeight * 0.55,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: screenHeight * 0.4,
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
                              offset: const Offset(0, 3),
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
                    // Кнопки добавления и отмены
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.13,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? AppColors.blackSand
                              : AppColors.whiteColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AddButton(
                              onPressed: () async {
                                if (_titleController.text.isNotEmpty &&
                                    _descriptionController.text.isNotEmpty &&
                                    _typeController.text.isNotEmpty) {
                                  try {
                                    if (_selectedImages.isNotEmpty) {
                                      _imageUrls =
                                      await _uploadImages(_selectedImages);
                                    }

                                    final type = _typeController.text.trim();
                                    if (!typeColorsCache.containsKey(type)) {
                                      typeColorsCache[type] = getRandomColor();
                                    }
                                    final randomColor = typeColorsCache[type]!;

                                    await FirebaseFirestore.instance
                                        .collection('item')
                                        .add({
                                      'title': _titleController.text,
                                      'description': _descriptionController.text,
                                      'type': type,
                                      'userId': FirebaseAuth
                                          .instance.currentUser?.uid,
                                      'color': randomColor,
                                      'typeColor': randomColor,
                                      'timestamp': Timestamp.now(),
                                      'imageUrls': _imageUrls,
                                      'quantity': 1,
                                    });

                                    Navigator.pop(context);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error: $e')),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Please fill all fields')),
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
                    )
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
