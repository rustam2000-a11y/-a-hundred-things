import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../home/widget/appBar/dropdown_container.dart';
import '../../home/widget/appBar/new_custom_app_bar.dart';
import '../../home/widget/type_dropdown_list.dart';
import 'create_new_thing_bloc.dart';
import 'widget/create_thing_bottom_bar.dart';
import 'widget/thing_image_placeholder.dart';
import 'widget/type_selector_dialog.dart';

class CreateNewThingScreen extends StatefulWidget {
  const CreateNewThingScreen(
      {super.key,
      required this.allTypes,
      this.existingThing,
      required this.isReadOnly});

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

  bool get isFormValid =>
      _titleController.text.trim().isNotEmpty &&
      _descriptionController.text.trim().isNotEmpty;

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
                    icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.black),
                    onPressed: () {
                      if (_existingDocId != null) {
                        _bloc.add(
                            ToggleFavoriteEvent(_existingDocId!, !_isFavorite));
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
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: double.infinity,
                    color: Colors.white,
                    child: state.file != null
                        ? Image.file(state.file!, fit: BoxFit.cover)
                        : (state.thing?.imageUrl?.isNotEmpty == true
                            ? Image.network(state.thing!.imageUrl!.first,
                                fit: BoxFit.cover)
                            : ThingImagePlaceholder(
                                screenWidth:
                                    MediaQuery.of(context).size.width)),
                  ),
                ),
                ExpandableFormCard(
                  isExpanded: _isExpanded,
                  titleController: _titleController,
                  descriptionController: _descriptionController,
                  quantityController: _quantityController,
                  isDarkMode: Theme.of(context).brightness == Brightness.dark,
                  screenHeight: MediaQuery.of(context).size.height,
                  screenWidth: MediaQuery.of(context).size.width,
                  importanceLevel: _selectedImportance,
                  onImportanceChanged: (value) =>
                      setState(() => _selectedImportance = value),
                  onExpandChanged: (value) =>
                      setState(() => _isExpanded = value),
                ),
                CreateThingBottomBar(
                  screenHeight: MediaQuery.of(context).size.height,
                  isDarkMode: Theme.of(context).brightness == Brightness.dark,
                  isFormValid: isFormValid,
                  selectedType: _selectedType,
                  titleController: _titleController,
                  descriptionController: _descriptionController,
                  quantityController: _quantityController,
                  selectedImportance: _selectedImportance,
                  isFavorite: _isFavorite,
                  existingDocId: _existingDocId,
                  stateFile: state.file,
                  stateThing: state.thing,
                  bloc: _bloc,
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
      builder: (context) => TypeSelectorDialog(types: _typeSet.toList()),
    ).then((selected) {
      if (selected != null) {
        setState(() {
          _selectedType = selected;
        });
      }
    });
  }
}
