import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';

abstract class SettingDataApiI {
  Future<String?> getCurrentUserUid();
  Future<Map<String, dynamic>> fetchUserProfile();
  Future<String> uploadUserAvatar(File image);
  Future<void> updateUserProfile({
    required String name,
    required String email,
    required String phone,
    required String password,
  });
}




@LazySingleton(as: SettingDataApiI)
class SettingDataApi implements SettingDataApiI {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Future<String?> getCurrentUserUid() async => _auth.currentUser?.uid;

  @override
  Future<Map<String, dynamic>> fetchUserProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('User not logged in');
    final doc = await _firestore.collection('user').doc(uid).get();
    if (!doc.exists) throw Exception('User profile not found');
    return doc.data()!;
  }

  @override
  Future<String> uploadUserAvatar(File image) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('User not logged in');

    final bytes = await image.readAsBytes();
    final filename = '$uid.jpg';
    final ref = _storage.ref().child('user_avatars/$filename');
    final taskSnapshot = await ref.putData(bytes);
    return taskSnapshot.ref.getDownloadURL();
  }

  @override
  Future<void> updateUserProfile({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('User not logged in');
    await _firestore.collection('user').doc(uid).update({
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
    });
  }
}