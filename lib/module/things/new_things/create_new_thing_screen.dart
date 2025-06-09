import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../presentation/colors.dart';
import '../../../repository/things_repository.dart';
import '../../home/widget/appBar/dropdown_container.dart';
import '../../home/widget/appBar/dropdown_title_widget.dart';
import '../../home/widget/appBar/new_custom_app_bar.dart';
import '../../home/widget/type_dropdown_list.dart';
import '../../login/widget/button_basic.dart';
import 'create_new_thing_bloc.dart';

class CreateNewThingScreen extends StatefulWidget {
  const CreateNewThingScreen({
    super.key,
    required this.allTypes,
  });

  final List<String> allTypes;

  @override
  State<CreateNewThingScreen> createState() => _CreateNewThingScreenState();
}

class _CreateNewThingScreenState extends State<CreateNewThingScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _importanceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();


  final ThingsRepositoryI thingsRepository = GetIt.I<ThingsRepositoryI>();
  final Map<String, String> typeColorsCache = {};
  List<String> _imageUrls = [];
  String? selectedType;

  final bool _showDrawer = false;
  final Set<String> _typeSet = {};

  late final CreateNewThingBloc _bloc;

  @override
  void initState() {
    _bloc = GetIt.I<CreateNewThingBloc>();
    _typeSet.addAll(widget.allTypes);
    super.initState();
  }

  String getRandomColor() {
    final random = Random();
    return '#${random.nextInt(0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
  }

  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<CreateNewThingBloc, CreateNewThingState>(
      bloc: _bloc,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: NewCustomAppBar(
            showSearchIcon: false,
            showBackButton: false,
            logo: WidgetDrawerContainer(
              typ: selectedType,
              onTap: () {
                showDialog<void>(
                  context: context,
                  builder: (context) => Dialog(
                    backgroundColor: Colors.transparent,
                    child: WidgetDrawer(
                      types: _typeSet.toList(),
                      onTypeSelected: (selected) {
                        setState(() {
                          selectedType = selected;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          body: SafeArea(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                if (_showDrawer && _typeSet.isNotEmpty)
                  WidgetDrawer(
                    types: _typeSet.toList(),
                    onTypeSelected: (selected) {
                      setState(() {
                        selectedType = selected;
                      });
                    },
                  ),
                GestureDetector(
                  onTap: () {
                    _bloc.add(ChangeImageEvent(context));
                  },
                  child: Container(
                    height: screenHeight * 0.5,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.white : Colors.white,
                    ),
                    child: Center(
                      child: state.file != null
                          ? Image.file(
                        state.file!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
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
                ExpandableFormCard(
                  isExpanded: _isExpanded,
                  titleController: _titleController,
                  descriptionController: _descriptionController,
                  locationController: _locationController,
                  priceController: _priceController,
                  weightController: _weightController,
                  colorController: _colorController,
                  importanceController: _importanceController,
                  quantityController: _quantityController,
                  isDarkMode: isDarkMode,
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  onExpandChanged: (value) {
                    setState(() {
                      _isExpanded = value;
                    });
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: screenHeight * 0.18,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.blackSand
                          : AppColors.whiteColor,
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
                              if (_titleController.text.isNotEmpty &&
                                  _descriptionController.text.isNotEmpty &&
                                  (selectedType?.isNotEmpty ?? false)) {
                                try {
                                  if (state.file != null) {
                                    _imageUrls =
                                    await thingsRepository.uploadImages([state.file!]);
                                  }

                                  final type = selectedType!.trim();
                                  if (!typeColorsCache.containsKey(type)) {
                                    typeColorsCache[type] = getRandomColor();
                                  }

                                  final randomColor = typeColorsCache[type]!;

                                  await FirebaseFirestore.instance.collection('item').add({
                                    'title': _titleController.text.trim(),
                                    'description': _descriptionController.text.trim(),
                                    'type': type,
                                    'userId': FirebaseAuth.instance.currentUser?.uid,
                                    'color': randomColor,
                                    'typeColor': randomColor,
                                    'timestamp': Timestamp.now(),
                                    'imageUrls': _imageUrls,
                                    'location': _locationController.text.trim(),
                                    'price': int.tryParse(_priceController.text.trim()) ?? 0,
                                    'weight': double.tryParse(_weightController.text.trim()) ?? 0,
                                    'colorText': _colorController.text.trim(),
                                    'importance': int.tryParse(_importanceController.text.trim()) ?? 0,
                                    'quantity': int.tryParse(_quantityController.text.trim()) ?? 1,
                                  });

                                  Navigator.pop(context);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error: $e')),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please fill all fields')),
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
      },
    );
  }
}
