import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../model/base_card_model.dart';

@LazySingleton(as: BaseDataApiI)
class BaseDataApi implements BaseDataApiI {
  FirebaseFirestore databaseReference = FirebaseFirestore.instance;

  @override
  Future<String> getCurrentUserUid() async {
    final User? userCredential = getCurrentUser();
    print('@@@ userCredential.user.uid=${userCredential?.uid}');
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
}

abstract class BaseDataApiI {
  Future<String> getCurrentUserUid();

  User? getCurrentUser();

  Stream<List<ThingsModel>> fetchAllThings();
}
