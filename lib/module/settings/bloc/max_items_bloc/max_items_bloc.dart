import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'max_items_event.dart';

part 'max_items_state.dart';

@Injectable()
class MaxItemsBloc extends Bloc<MaxItemsEvent, MaxItemsState> {
  MaxItemsBloc() : super(const MaxItemsState()) {
    on<MaxItemsInitEvent>((event, emit) {
      init(event.initialValue, emit);
    });

    on<MaxItemsChangedEvent>((event, emit) {
      changeMaxItems(event.value, emit);
    });

    on<MaxItemsSpecialChangedEvent>((event, emit) {
      updateSpecial(event.value, emit);
    });

    on<MaxItemsSubmittedEvent>((event, emit) {
      submit(emit);
    });
  }

  Future<void> init(int initialValue, Emitter<MaxItemsState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final savedSpecial = prefs.getBool('isSpecial') ?? false;

    emit(state.copyWith(
      isSpecial: savedSpecial,
      maxItems: initialValue,
    ));
  }

  void changeMaxItems(int value, Emitter<MaxItemsState> emit) {
    emit(state.copyWith(
      maxItems: value,
      errorText: null,
    ));
  }

  void updateSpecial(bool value, Emitter<MaxItemsState> emit) {
    emit(state.copyWith(isSpecial: value));

    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('isSpecial', value);
    });
  }

  Future<void> submit(Emitter<MaxItemsState> emit) async {
    final value = state.maxItems;

    if (value < 1 || value > 1000) {
      emit(state.copyWith(errorText: 'Please enter a number from 1 to 1000'));
      return;
    }

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await FirebaseFirestore.instance.collection('user').doc(userId).set({
        'maxItems': value,
        'isSpecial': state.isSpecial,
      }, SetOptions(merge: true));
    }

    emit(state.copyWith(done: true));
  }

  Future<void> _saveSpecial(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSpecial', value);
  }
}
