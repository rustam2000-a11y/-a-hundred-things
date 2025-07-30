import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/image_picker.dart';
import '../../../../generated/l10n.dart';
import '../../../../presentation/colors.dart';
import '../../../login/widget/button_basic.dart';
import '../../../things/new_things/create_new_thing_bloc.dart';
import '../../../things/new_things/widget/image_pager_with_indicator.dart';
import '../appBar/dropdown_title_widget.dart';
import '../appBar/new_custom_app_bar.dart';


class AddTypePage extends StatefulWidget {
  const AddTypePage({
    super.key,
    this.initialType,
    this.initialDescription,
    this.initialImageUrls,
    this.isEditing = false,
    this.editingItemId,
  });

  final String? initialType;
  final String? initialDescription;
  final List<String>? initialImageUrls;
  final bool isEditing;
  final String? editingItemId;

  @override
  State<AddTypePage> createState() => _AddTypePageState();
}

class _AddTypePageState extends State<AddTypePage> {
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final Map<String, String> typeColorsCache = {};
  final Set<String> _typeSet = {};

  final List<String> _imageUrls = [];

  bool isFormFilled = false;
  final bool _showDrawer = false;
  final List<File> _selectedImages = [];

  @override
  void initState() {
    super.initState();
    _typeController.text = widget.initialType ?? '';
    _descriptionController.text = widget.initialDescription ?? '';
    _descriptionController.addListener(_checkFormFilled);
    _typeController.addListener(_checkFormFilled);
  }

  void _checkFormFilled() {
    final filled = _descriptionController.text.isNotEmpty && _typeController.text.isNotEmpty;
    if (filled != isFormFilled) {
      setState(() {
        isFormFilled = filled;
      });
    }
  }

  Future<void> _pickAndCropImage() async {
    final File? croppedImage = await ImagePickerHelper.pickImage();
    if (croppedImage != null) {
      setState(() {
        _selectedImages.add(croppedImage);
      });
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
                height: screenHeight * 0.45,
                width: double.infinity,
                decoration: const BoxDecoration(color: Colors.white),
                child: _selectedImages.isNotEmpty
                    ? ImagePagerWithIndicator(
                  files: _selectedImages,
                  urls: _imageUrls,
                  screenHeight: screenHeight * 0.5,
                  onRemove: (index) {
                    setState(() {
                      _selectedImages.removeAt(index);
                    });
                  },
                )


                    : Center(
                  child: Container(
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        suffixIcon: Icon(Icons.edit,
                            color: isDarkMode ? Colors.white : Colors.black),
                      ),
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
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
                  color: isDarkMode ? AppColors.blackSand : AppColors.whiteColor,
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
                        isEnabled: isFormFilled,
                        onPressed: () async {
                          final type = _typeController.text.trim();
                          final description = _descriptionController.text.trim();
                          final bloc = context.read<CreateNewThingBloc>()

                          ..add(SaveTypeEvent(
                            type: type,
                            description: description,
                            isEditing: widget.isEditing,
                            editingItemId: widget.editingItemId,
                            files: _selectedImages,
                          ));

                          Navigator.pop(context, type);
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
