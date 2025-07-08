import 'package:flutter/material.dart';
import '../../../../model/things_model.dart';
import '../../../../presentation/colors.dart';
import '../../../login/widget/button_basic.dart';
import '../create_new_thing_bloc.dart';

class CreateThingBottomBar extends StatelessWidget {
  const CreateThingBottomBar({
    super.key,
    required this.screenHeight,
    required this.isDarkMode,
    required this.isFormValid,
    required this.selectedType,
    required this.titleController,
    required this.descriptionController,
    required this.quantityController,
    required this.selectedImportance,
    required this.isFavorite,
    required this.existingDocId,
    required this.stateFile,
    required this.stateThing,
    required this.bloc,
  });

  final double screenHeight;
  final bool isDarkMode;
  final bool isFormValid;
  final String? selectedType;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController quantityController;
  final String selectedImportance;
  final bool isFavorite;
  final String? existingDocId;
  final dynamic stateFile;
  final dynamic stateThing;
  final CreateNewThingBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Align(
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
                isEnabled: isFormValid && selectedType != null,
                onPressed: () {
                  final model = ThingsModel(
                    id: existingDocId ?? '',
                    title: titleController.text.trim(),
                    description: descriptionController.text.trim(),
                    type: selectedType ?? '',
                    typDescription: '',
                    color: '',
                    imageUrl: stateFile != null ? [] : stateThing?.imageUrl ?? [],
                    quantity: int.tryParse(quantityController.text.trim()) ?? 1,
                    importance: selectedImportance,
                    favorites: isFavorite,
                  );
                  bloc.add(SaveThingEvent(model));
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
    );
  }
}
