import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
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
      await _changeImage(event.context, emit);
    });
  }

  final ImagePickerService imagePickerService;

  Future<void> _changeImage(
      BuildContext context, Emitter<CreateNewThingState> emit) async {
    final file = await imagePickerService.pickAndCropImage(context);
    if (file != null) {
      emit(state.copyWith(file: file));
    }
  }
}
