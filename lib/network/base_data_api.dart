import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  Stream<List<ThingsModel>> searchThingsByTitle(String searchQuery) {
    return FirebaseFirestore.instance
        .collection('item')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .where((item) {
        final title = (item['title'] as String?)?.toLowerCase() ?? '';
        return title.contains(searchQuery);
      })
          .map((doc) => ThingsModel.fromJson(doc.data()).copyWith(id: doc.id))
          .toList();
    });
  }

  @override
  Future<List<String>> uploadImages(List<File> images) async {
    final List<String> urls = [];

    for (final image in images) {
      try {
        if (!image.existsSync()) {
          throw Exception('Файл не существует: ${image.path}');
        }

        final fileLength = await image.length();
        if (fileLength == 0) {
          throw Exception('Файл пустой: ${image.path}');
        }

        final bytes = await image.readAsBytes();
        final filename = '${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}';
        final ref = FirebaseStorage.instance.ref().child('item_images/$filename');

        print('Uploading BYTES from file: ${image.path}');
        final taskSnapshot = await ref.putData(bytes);
        final downloadUrl = await taskSnapshot.ref.getDownloadURL();
        print('Uploaded file: $downloadUrl');

        urls.add(downloadUrl);
      } on FirebaseException catch (e) {
        print('🔥 Firebase Storage error: code=${e.code}, message=${e.message}');
        throw Exception('Ошибка Firebase: ${e.message}');
      } catch (e) {
        print('❌ Unknown error: $e');
        throw Exception('Ошибка при загрузке: $e');
      }
    }

    return urls;
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

  Stream<List<ThingsModel>> searchThingsByTitle(String searchQuery);
  Future<List<String>> uploadImages(List<File> images);
}
