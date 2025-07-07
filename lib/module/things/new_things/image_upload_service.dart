import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

abstract class ImageUploadService {
  Future<String> uploadImage(File file);
}

@LazySingleton(as: ImageUploadService)
class FirebaseImageUploadService implements ImageUploadService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Future<String> uploadImage(File file) async {
    final ref = _storage.ref().child('things/${const Uuid().v4()}.jpg');
    final bytes = await file.readAsBytes();
    final task = await ref.putData(bytes);
    return task.ref.getDownloadURL();
  }

}
