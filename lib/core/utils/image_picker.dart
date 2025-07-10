import 'dart:io';
import 'dart:typed_data';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  ImagePickerHelper();

  static Future<File?> pickImage() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image == null) return null;
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        maxHeight: 1024,
        maxWidth: 2048,
      );
      if (croppedFile == null) return null;
      final Uint8List imageBytes = await croppedFile.readAsBytes();

      final tempDir = Directory.systemTemp;
      final tempFile = File(
          '${tempDir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.png');
      await tempFile.writeAsBytes(imageBytes);

      int retryCount = 0;
      while ((!tempFile.existsSync() || await tempFile.length() == 0) &&
          retryCount < 5) {
        await Future<void>.delayed(const Duration(milliseconds: 200));
        retryCount++;
      }

      return tempFile;
    } on Exception catch (e) {
      print(e);
    }
    return null;
  }
}
