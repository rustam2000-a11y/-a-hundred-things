import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:injectable/injectable.dart';

import 'image_picker_servirs.dart';

part 'create_new_thing_event.dart';

part 'create_new_thing_state.dart';

@Injectable()
class CreateNewThingBloc
    extends Bloc<CreateNewThingEvent, CreateNewThingState> {
  CreateNewThingBloc(this.imagePickerService)
      : super(const CreateNewThingState()) {
    on<SetNewImageEvent>((event, emit) {
      emit(state.copyWith(file: event.file));
    });

    on<ChangeImageEvent>((event, emit) async {
      await _changeImage(
        event.context,
        emit,
        onTitleDetected: event.onTitleDetected,
      );
    });

  }

  final ImagePickerService imagePickerService;



  Future<void> _changeImage(
      BuildContext context,
      Emitter<CreateNewThingState> emit, {
        required void Function(String detectedTitle) onTitleDetected,
      }) async {
    final file = await imagePickerService.pickAndCropImage(context);
    if (file == null) return;

    emit(state.copyWith(file: file));
    final inputImage = InputImage.fromFile(file);
    final labeler = ImageLabeler(
      options: ImageLabelerOptions(confidenceThreshold: 0.7),
    );
    final labels = await labeler.processImage(inputImage);
    await labeler.close();

    if (labels.isNotEmpty) {
      final bestLabel = labels.first.label;
      onTitleDetected(bestLabel);
    }
  }


}
