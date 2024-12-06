import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../presentation/colors.dart';
import 'bottom_container_button.dart';

void showEditItemBottomSheet(
    BuildContext context, {
      required String itemId,
      required String initialTitle,
      required String initialDescription,
      required String initialType,
      String? initialImageUrl,
    }) {
  final TextEditingController _titleController =
  TextEditingController(text: initialTitle);
  final TextEditingController _descriptionController =
  TextEditingController(text: initialDescription);
  final TextEditingController _typeController =
  TextEditingController(text: initialType);

  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
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
        builder: (context, setState) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                height: screenHeight,
                color: isDarkMode ? AppColors.blackSand : Colors.white,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [

                    GestureDetector(
                      onTap: () async {
                        await _pickImage();
                        setState(() {});
                      },
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
                            width: screenWidth,
                            height: screenHeight * 0.6,
                          )
                              : (initialImageUrl != null
                              ? Image.network(
                            initialImageUrl,
                            fit: BoxFit.cover,
                            width: screenWidth,
                            height: screenHeight * 0.6,
                          )
                              : Container(
                            width: screenWidth * 0.5,
                            height: screenWidth * 0.5,
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? AppColors.greySand
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.edit,
                              color: isDarkMode
                                  ? Colors.white : Colors.black,
                              size: screenWidth * 0.15,
                            ),
                          )),
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
                            hintText: "Тип",
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
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            TextField(
                              controller: _titleController,
                              decoration: InputDecoration(
                                labelText: "Название предмета",
                                labelStyle: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.grey[600],
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            TextField(
                              controller: _descriptionController,
                              decoration: InputDecoration(
                                labelText: "Описание предмета",
                                labelStyle: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.grey[600],
                                ),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
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
                        child: SafeArea(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SaveButton(
                                onPressed: () async {
                                  if (_titleController.text.isNotEmpty &&
                                      _descriptionController.text.isNotEmpty &&
                                      _typeController.text.isNotEmpty) {
                                    try {
                                      String? newImageUrl = initialImageUrl;


                                      if (_selectedImage != null) {
                                        final storageRef = FirebaseStorage
                                            .instance
                                            .ref()
                                            .child(
                                            'images/${itemId}_${DateTime.now().millisecondsSinceEpoch}');
                                        await storageRef.putFile(
                                            _selectedImage!);
                                        newImageUrl =
                                        await storageRef.getDownloadURL();
                                      }

                                      // Обновляем документ Firestore
                                      await FirebaseFirestore.instance
                                          .collection('item')
                                          .doc(itemId)
                                          .update({
                                        'title': _titleController.text,
                                        'description':
                                        _descriptionController.text,
                                        'type': _typeController.text,
                                        'imageUrl': newImageUrl,
                                        'timestamp': Timestamp.now(),
                                      });

                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Item updated successfully')),
                                      );
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
                              const SizedBox(width: 10),
                              CancelButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
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

