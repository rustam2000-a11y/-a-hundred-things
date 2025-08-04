import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/image_picker.dart';
import '../../../../core/utils/internet_banner_overlay.dart';
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

class _AddTypePageState extends State<AddTypePage> with WidgetsBindingObserver {
  final Set<String> _typeSet = {};
  final bool _showDrawer = false;
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<CreateNewThingBloc>().add(
          InitTypeFormEvent(
            initialType: widget.initialType,
            initialDescription: widget.initialDescription,
          ),
        );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final isVisible = bottomInset > 0.0;
    if (_isKeyboardVisible != isVisible) {
      setState(() {
        _isKeyboardVisible = isVisible;
      });
    }
  }

  Future<void> _pickAndCropImage() async {
    final File? croppedImage = await ImagePickerHelper.pickImage();
    if (croppedImage != null) {
      context.read<CreateNewThingBloc>().add(AddImageEvent(croppedImage));
    }
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
      body: BlocConsumer<CreateNewThingBloc, CreateNewThingState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }

          if (state.isSuccess) {
            Navigator.pop(context, state.type.trim());
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                if (_showDrawer && _typeSet.isNotEmpty)
                  WidgetDrawer(
                    types: _typeSet.toList(),
                    onTypeSelected: (selectedType) {
                      context.read<CreateNewThingBloc>().add(
                            TypeChangedEvent(selectedType),
                          );
                    },
                  ),
                GestureDetector(
                  onTap: _pickAndCropImage,
                  child: Container(
                    height: screenHeight * 0.45,
                    width: double.infinity,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: state.files.isNotEmpty
                        ? ImagePagerWithIndicator(
                            files: state.files,
                            urls: widget.initialImageUrls ?? [],
                            screenHeight: screenHeight * 0.5,
                            onRemove: (index) {
                              context
                                  .read<CreateNewThingBloc>()
                                  .add(RemoveImageEvent(index));
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
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeInOut,
                  top: _isKeyboardVisible
                      ? screenHeight * 0.15
                      : screenHeight * 0.45,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: screenHeight * 0.6,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                          onChanged: (value) => context
                              .read<CreateNewThingBloc>()
                              .add(TypeChangedEvent(value)),
                          controller: TextEditingController.fromValue(
                            TextEditingValue(
                              text: state.type,
                              selection: TextSelection.collapsed(
                                  offset: state.type.length),
                            ),
                          ),
                          decoration: InputDecoration(
                            hintText: 'CATEGORY NAME',
                            border: InputBorder.none,
                            suffixIcon: Icon(
                              Icons.edit,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          onChanged: (value) => context
                              .read<CreateNewThingBloc>()
                              .add(DescriptionChangedEvent(value)),
                          controller: TextEditingController.fromValue(
                            TextEditingValue(
                              text: state.description,
                              selection: TextSelection.collapsed(
                                  offset: state.description.length),
                            ),
                          ),
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
                            isEnabled: state.isFormFilled,
                            onPressed: () {
                              context.read<CreateNewThingBloc>().add(
                                    SaveTypeEvent(
                                      type: state.type.trim(),
                                      description: state.description.trim(),
                                      isEditing: widget.isEditing,
                                      editingItemId: widget.editingItemId,
                                      files: state.files,
                                    ),
                                  );
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
                const Align(
                  alignment: Alignment.topCenter,
                  child: InternetBannerOverlay(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
