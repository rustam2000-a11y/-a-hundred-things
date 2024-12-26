import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../model/things_model.dart';

@LazySingleton(as: BaseDataApiI)
class BaseDataApi implements BaseDataApiI {
  FirebaseFirestore databaseReference = FirebaseFirestore.instance;

  @override
  Future<String> getCurrentUserUid() async {
    final User? userCredential = getCurrentUser();
    log('@@@ userCredential.user.uid=${userCredential?.uid}');
    return userCredential!.uid;
  }

  @override
  User? getCurrentUser() {
    final User? credential = FirebaseAuth.instance.currentUser;
    return credential;
  }

  @override
  Stream<List<ThingsModel>> fetchAllThings() {
    return Stream.fromFuture(getCurrentUserUid()).asyncExpand(
      (userUid) => databaseReference
          .collection('item')
          .where('userId', isEqualTo: userUid)
          .snapshots()
          .map(
            (event) => event.docs
                .map((e) => ThingsModel.fromJson(e.data()).copyWith(id: e.id))
                .toList(),
          ),
    );
  }

  @override
  Future<void> deleteThingsByType(String type) async {
    final items = await databaseReference
        .collection('item')
        .where('type', isEqualTo: type)
        .get();

    for (final doc in items.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Future<void> deleteItemByUid(String uid) async {
    await databaseReference.collection('item').doc(uid).delete();
  }
}

abstract class BaseDataApiI {
  Future<String> getCurrentUserUid();

  User? getCurrentUser();

  Stream<List<ThingsModel>> fetchAllThings();

  Future<void> deleteThingsByType(String type);

  Future<void> deleteItemByUid(String uid);
}
