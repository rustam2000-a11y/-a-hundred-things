import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';



@LazySingleton(as: NavigatorDataApiI)
class NavigatorDataApi implements NavigatorDataApiI {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Stream<int> fetchMaxItems() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      log('⚠️ fetchMaxItems: user is null');
      return Stream.value(100);
    }

    return _firestore
        .collection('user')
        .doc(uid)
        .snapshots()
        .map((snapshot) => (snapshot.data()?['maxItems'] ?? 100) as int);
  }

  @override
  Stream<int> fetchTotalQuantity() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      log('⚠️ fetchTotalQuantity: user is null');
      return Stream.value(0);
    }

    return _firestore
        .collection('item')
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
      int total = 0;

      for (final doc in snapshot.docs) {
        final title = doc['title'];
        if (title != null && title.toString().trim().isNotEmpty) {
          total += doc['quantity'] as int? ?? 1;
        }
      }

      return total;
    });
  }
}
abstract class NavigatorDataApiI {
  Stream<int> fetchMaxItems();
  Stream<int> fetchTotalQuantity();
}