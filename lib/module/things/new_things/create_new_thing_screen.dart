
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../model/things_model.dart';
import '../../../presentation/colors.dart';
import '../../home/widget/appBar/dropdown_container.dart';
import '../../home/widget/appBar/dropdown_title_widget.dart';
import '../../home/widget/appBar/new_custom_app_bar.dart';
import '../../home/widget/type_dropdown_list.dart';
import '../../login/widget/button_basic.dart';
import 'create_new_thing_bloc.dart';

class CreateNewThingScreen extends StatefulWidget {
  const CreateNewThingScreen({super.key, required this.allTypes, this.existingThing, required this.isReadOnly});

  final List<String> allTypes;
  final Map<String, dynamic>? existingThing;
  final bool isReadOnly;
  @override
  State<CreateNewThingScreen> createState() => _CreateNewThingScreenState();
}

class _CreateNewThingScreenState extends State<CreateNewThingScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _typeSet = <String>{};

  late final CreateNewThingBloc _bloc;
  bool _isFavorite = false;
  bool _isExpanded = false;
  String? _existingDocId;
  String? _selectedType;
  String _selectedImportance = 'Medium';

  bool get isFormValid => _titleController.text.trim().isNotEmpty && _descriptionController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _bloc = GetIt.I<CreateNewThingBloc>();
    _typeSet.addAll(widget.allTypes);

    if (widget.existingThing != null) {
      _existingDocId = widget.existingThing!['id'] as String?;
      if (_existingDocId != null) {
        _bloc.add(LoadThingEvent(_existingDocId!));
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<CreateNewThingBloc, CreateNewThingState>(
      bloc: _bloc,
      listener: (context, state) {
        final thing = state.thing;
        if (thing != null) {
          _isFavorite = thing.favorites;
          _titleController.text = thing.title;
          _descriptionController.text = thing.description;
          _quantityController.text = thing.quantity.toString();
          _selectedType = thing.type;
          _selectedImportance = thing.importance;
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: NewCustomAppBar(
            showSearchIcon: false,
            showBackButton: false,
            actionIcon: _existingDocId != null
                ? IconButton(
              icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.black),
              onPressed: () {
                if (_existingDocId != null) {
                  _bloc.add(ToggleFavoriteEvent(_existingDocId!, !_isFavorite));
                  setState(() => _isFavorite = !_isFavorite);
                }
              },
            )
                : null,
            logo: WidgetDrawerContainer(
              typ: _selectedType,
              onTap: () => _showTypeSelector(context),
            ),
          ),
          body: SafeArea(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                GestureDetector(
                  onTap: () {
                    _bloc.add(ChangeImageEvent(context, (detectedTitle) {
                      setState(() {
                        _titleController.text = detectedTitle;
                      });
                    }));
                  },
                  child: Container(
                    height: screenHeight * 0.4,
                    width: double.infinity,
                    color: Colors.white,
                    child: state.file != null
                        ? Image.file(state.file!, fit: BoxFit.cover)
                        : (state.thing?.imageUrl?.isNotEmpty == true
                        ? Image.network(state.thing!.imageUrl!.first, fit: BoxFit.cover)
                        : _buildPlaceholder(screenWidth)),
                  ),
                ),
                ExpandableFormCard(
                  isExpanded: _isExpanded,
                  titleController: _titleController,
                  descriptionController: _descriptionController,
                  quantityController: _quantityController,
                  isDarkMode: isDarkMode,
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  importanceLevel: _selectedImportance,
                  onImportanceChanged: (value) => setState(() => _selectedImportance = value),
                  onExpandChanged: (value) => setState(() => _isExpanded = value),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: screenHeight * 0.16,
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
                            isEnabled: isFormValid && _selectedType != null,
                            onPressed: () {
                              final model = ThingsModel(
                                id: _existingDocId ?? '',
                                title: _titleController.text.trim(),
                                description: _descriptionController.text.trim(),
                                type: _selectedType ?? '',
                                typDescription: '',
                                color: '',
                                imageUrl: state.file != null ? [] : state.thing?.imageUrl ?? [],
                                quantity: int.tryParse(_quantityController.text.trim()) ?? 1,
                                importance: _selectedImportance,
                                favorites: _isFavorite,
                              );
                              _bloc.add(SaveThingEvent(model));
                              Navigator.pop(context, true);
                            },
                          ),
                          CustomMainButton(
                            text: 'DELETE',
                            onPressed: () => Navigator.pop(context, true),
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

  void _showTypeSelector(BuildContext context) {
    showDialog<String>(
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
                  Navigator.of(context).pop(selected);
                },
              ),
            ),
          ),
        ),
      ),
    ).then((selected) {
      if (selected != null) {
        setState(() => _selectedType = selected);
      }
    });
  }


  Widget _buildPlaceholder(double screenWidth) {
    return Container(
      width: screenWidth * 0.5,
      height: screenWidth * 0.5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Image.asset(
          'assets/images/camera_icon.png',
          width: screenWidth * 0.18,
          height: screenWidth * 0.18,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
