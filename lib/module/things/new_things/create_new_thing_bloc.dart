import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:injectable/injectable.dart';

import '../../../model/things_model.dart';
import '../../../repository/create_new_thing_repository.dart';
import 'image_picker_servirs.dart';
import 'image_upload_service.dart';

part 'create_new_thing_event.dart';

part 'create_new_thing_state.dart';

@Injectable()
class CreateNewThingBloc
    extends Bloc<CreateNewThingEvent, CreateNewThingState> {
  CreateNewThingBloc(
    this.imagePickerService,
    this.repository,
    this.imageUploadService,
  ) : super(const CreateNewThingState()) {
    on<SetNewImageEvent>((event, emit) {
      emit(state.copyWith(file: event.file));
    });

    on<ChangeImageEvent>(_changeImage);
    on<LoadThingEvent>(_loadThing);
    on<SaveThingEvent>(_saveThing);
    on<ToggleFavoriteEvent>(_toggleFavorite);
  }

  final ImagePickerService imagePickerService;
  final CreateThingRepositoryI repository;
  final ImageUploadService imageUploadService;

  Future<void> _changeImage(
    ChangeImageEvent event,
    Emitter<CreateNewThingState> emit,
  ) async {
    final file = await imagePickerService.pickAndCropImage(event.context);
    if (file == null) return;

    emit(state.copyWith(file: file));
    final inputImage = InputImage.fromFile(file);
    final labeler =
        ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.7));
    final labels = await labeler.processImage(inputImage);
    await labeler.close();

    if (labels.isNotEmpty) {
      event.onTitleDetected(labels.first.label);
    }
  }

  Future<void> _loadThing(
    LoadThingEvent event,
    Emitter<CreateNewThingState> emit,
  ) async {
    final model = await repository.fetchThing(event.docId);
    if (model != null) {
      emit(state.copyWith(thing: model));
    }
  }

  Future<void> _saveThing(
    SaveThingEvent event,
    Emitter<CreateNewThingState> emit,
  ) async {
    List<String> uploadedUrls = event.model.imageUrl ?? [];

    if (state.file != null) {
      final url = await imageUploadService.uploadImage(state.file!);
      uploadedUrls = [url];
    }

    final isCreating = event.model.id.isEmpty;
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    if (isCreating) {
      final modelToSave = event.model.copyWith(
        imageUrl: uploadedUrls,
        id: '',
        userId: userId,
      );
      final ref = await FirebaseFirestore.instance
          .collection('item')
          .add(modelToSave.toJson(includeId: false));
      await ref.update({'id': ref.id});
    } else {
      final modelToUpdate = event.model.copyWith(
        imageUrl: uploadedUrls,
        userId: userId,
      );
      await FirebaseFirestore.instance
          .collection('item')
          .doc(modelToUpdate.id)
          .update(modelToUpdate.toJson());
    }
  }

  Future<void> _toggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<CreateNewThingState> emit,
  ) async {
    await repository.updateFavorite(event.docId, event.isFavorite);
  }
}
