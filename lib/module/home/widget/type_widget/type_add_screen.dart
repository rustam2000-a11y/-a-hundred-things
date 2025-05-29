import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cropperx/cropperx.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../generated/l10n.dart';
import '../../../../presentation/colors.dart';
import '../../../../repository/things_repository.dart';
import '../../../login/widget/button_basic.dart';
import '../appBar/dropdown_title_widget.dart';
import '../appBar/new_custom_app_bar.dart';

class AddTypePage extends StatefulWidget {
  const AddTypePage({
    super.key,
  });

  @override
  State<AddTypePage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddTypePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final ThingsRepositoryI thingsRepository = GetIt.I<ThingsRepositoryI>();
  final List<File> _selectedImages = [];
  final Map<String, String> typeColorsCache = {};
  List<String> _imageUrls = [];
  String? selectedType;

  final bool _showDrawer = false;
  final Set<String> _typeSet = {};

  @override
  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickAndCropImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final cropperKey = GlobalKey(debugLabel: 'cropperKey');
        final File imageFile = File(pickedFile.path);

        await showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Column(
                children: [
                  Expanded(
                    child: Cropper(
                      cropperKey: cropperKey,
                      image: Image.file(imageFile),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final imageBytes =
                          await Cropper.crop(cropperKey: cropperKey);
                      if (imageBytes != null) {
                        final tempDir = Directory.systemTemp;
                        final tempFile = File(
                            '${tempDir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.png');
                        await tempFile.writeAsBytes(imageBytes);
                        setState(() {
                          _selectedImages.add(tempFile);
                        });
                      }
                      Navigator.pop(context);
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

  String getRandomColor() {
    final random = Random();
    return '#${random.nextInt(0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const NewCustomAppBar(
        showSearchIcon: false,
        showBackButton: false,
        logo: SizedBox.shrink(),
      ),
      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (_showDrawer && _typeSet.isNotEmpty)
              WidgetDrawer(
                types: _typeSet.toList(),
                onTypeSelected: (selectedType) {
                  setState(() {
                    _typeController.text = selectedType;
                  });
                },
              ),
            GestureDetector(
              onTap: _pickAndCropImage,
              child: Container(
                height: screenHeight * 0.5,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.white : Colors.white,
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
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.add_a_photo_rounded,
                            color: AppColors.grey,
                            size: screenWidth * 0.18,
                          ),
                        ),
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.45,
              left: 0,
              right: 0,
              child: Container(
                height: screenHeight * 0.6,
                padding: EdgeInsets.all(screenWidth * 0.05),
                decoration: BoxDecoration(
                  gradient: isDarkMode ? AppColors.darkBlueGradient : null,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: const Border(top: BorderSide()),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _typeController,
                      decoration: InputDecoration(
                        hintText: 'CATEGORY NAME',
                        border: InputBorder.none,
                        suffixIcon: Icon(Icons.edit, color: isDarkMode ? Colors.white : Colors.black),
                      ),
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),


                    SizedBox(height: screenHeight * 0.02),
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        hintText: S.of(context).description,
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
                height: screenHeight * 0.15,
                decoration: BoxDecoration(
                  color:
                      isDarkMode ? AppColors.blackSand : AppColors.whiteColor,
                  border: const Border(top: BorderSide()),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomMainButton(
                        text: 'SAVE',
                        textColor: Colors.white,
                        backgroundColor: Colors.black,
                        onPressed: () async {
                          if (
                              _descriptionController.text.isNotEmpty &&
                              _typeController.text.isNotEmpty) {
                            try {
                              if (_selectedImages.isNotEmpty) {
                                _imageUrls = await thingsRepository
                                    .uploadImages(_selectedImages);
                              }

                              final type = _typeController.text.trim();
                              if (!typeColorsCache.containsKey(type)) {
                                typeColorsCache[type] = getRandomColor();
                              }

                              final randomColor = typeColorsCache[type]!;

                              await FirebaseFirestore.instance
                                  .collection('item')
                                  .add({
                                'title': _titleController.text.trim(),
                                'typDescription': _descriptionController.text.trim(),
                                'type': type,
                                'userId': FirebaseAuth.instance.currentUser?.uid,
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
                      CustomMainButton(
                        text: 'DELETE',
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
    );
  }
}
