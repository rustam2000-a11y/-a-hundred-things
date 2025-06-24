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
    this.isReadOnly = false,
    this.existingThing,
  });

  final List<String> allTypes;
  final bool isReadOnly;
  final Map<String, dynamic>? existingThing;

  @override
  State<CreateNewThingScreen> createState() => _CreateNewThingScreenState();
}

class _CreateNewThingScreenState extends State<CreateNewThingScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _importanceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  final ThingsRepositoryI thingsRepository = GetIt.I<ThingsRepositoryI>();
  final Map<String, String> typeColorsCache = {};
  List<String> _imageUrls = [];
  String? selectedType;
  String? existingDocId;
  bool isFormValid = false;
  final bool _showDrawer = false;
  final Set<String> _typeSet = {};
  bool isEditMode = false;
  bool _isFavorite = false;

  late final CreateNewThingBloc _bloc;

  void _validateForm() {
    final valid = _titleController.text.trim().isNotEmpty &&
        _descriptionController.text.trim().isNotEmpty;

    if (isFormValid != valid) {
      setState(() {
        isFormValid = valid;
      });
    }
  }

  @override
  @override
  void initState() {
    super.initState();

    _bloc = GetIt.I<CreateNewThingBloc>();
    _typeSet.addAll(widget.allTypes);

    _titleController.addListener(_validateForm);
    _descriptionController.addListener(_validateForm);

    isEditMode = widget.existingThing != null;

    if (isEditMode) {
      final data = widget.existingThing!;
      _isFavorite = data['favorites'] ?? false;
      existingDocId = data['id'];
      _titleController.text = data['title'] ?? '';
      _descriptionController.text = data['description'] ?? '';
      _importanceController.text = (data['importance'] ?? '').toString();
      _quantityController.text = (data['quantity'] ?? '1').toString();
      selectedType = data['type'];
      final imageUrlRaw = data['imageUrls'];
      if (imageUrlRaw is List<String>) {
        _imageUrls = imageUrlRaw;
      } else if (imageUrlRaw is List) {
        _imageUrls = List<String>.from(imageUrlRaw.whereType<String>());
      }
    }

    _validateForm();
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
            actionIcon: IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.black,
                ),
                onPressed: () async {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });

                  print('existingDocId: $existingDocId');

                  if (existingDocId != null) {
                    await FirebaseFirestore.instance
                        .collection('item')
                        .doc(existingDocId)
                        .update({'favorites': _isFavorite});

                    Navigator.pop(context, true);
                  } else {
                    print('ERROR: existingDocId is null');
                  }
                }),
            logo: WidgetDrawerContainer(
              typ: selectedType,
              onTap: () {
                showDialog<void>(
                  context: context,
                  builder: (context) => Dialog(
                    backgroundColor: Colors.transparent,

                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.of(context).pop(),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {},
                          child: WidgetDrawer(
                            types: _typeSet.toList(),
                            onTypeSelected: (selected) {
                              setState(() {
                                selectedType = selected;
                              });

                            },
                          ),
                        ),
                      ),
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
                    height: screenHeight * 0.4,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.white : Colors.white,
                    ),
                    child: (state.file != null && !isEditMode)
                        ? Image.file(
                            state.file!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          )
                        : _imageUrls.isNotEmpty
                            ? Image.network(
                                _imageUrls.first,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  print('Image load error: $error');
                                  return const Center(
                                      child: Icon(Icons.broken_image));
                                },
                              )
                            : _buildPlaceholder(screenWidth),
                  ),
                ),
                ExpandableFormCard(
                  isExpanded: _isExpanded,
                  titleController: _titleController,
                  descriptionController: _descriptionController,
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
                    height: screenHeight * 0.16,
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
                            isEnabled: isFormValid,
                            onPressed: () async {
                              try {
                                if (state.file != null) {
                                  _imageUrls = await thingsRepository
                                      .uploadImages([state.file!]);
                                }

                                final type = selectedType!.trim();
                                if (!typeColorsCache.containsKey(type)) {}

                                final Map<String, dynamic> itemData = {
                                  'title': _titleController.text.trim(),
                                  'description':
                                      _descriptionController.text.trim(),
                                  'type': type,
                                  'userId':
                                      FirebaseAuth.instance.currentUser?.uid,
                                  'timestamp': Timestamp.now(),
                                  'imageUrls': _imageUrls,
                                  'importance': int.tryParse(
                                          _importanceController.text.trim()) ??
                                      0,
                                  'quantity': int.tryParse(
                                          _quantityController.text.trim()) ??
                                      1,
                                  'favorites': _isFavorite,
                                };

                                if (existingDocId != null) {
                                  await FirebaseFirestore.instance
                                      .collection('item')
                                      .doc(existingDocId)
                                      .update(itemData);
                                } else {
                                  await FirebaseFirestore.instance
                                      .collection('item')
                                      .add(itemData);
                                }

                                Navigator.pop(context);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $e')),
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

Widget _buildPlaceholder(double screenWidth) {
  return Container(
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
  );
}
