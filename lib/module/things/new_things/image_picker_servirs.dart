import 'dart:io';
import 'package:cropperx/cropperx.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ImagePickerService {
  final ImagePicker _picker = ImagePicker();
  Future<File?> pickAndCropImage(BuildContext context) async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return null;

      final cropperKey = GlobalKey(debugLabel: 'cropperKey');
      final File imageFile = File(pickedFile.path);
      File? resultFile;

      await showDialog<void>(
        context: context,
        builder: (context) {
          return Dialog(
            child: Column(
              children: [
                Expanded(child: Cropper(cropperKey: cropperKey, image: Image.file(imageFile))),
                TextButton(
                  onPressed: () async {
                    final imageBytes = await Cropper.crop(cropperKey: cropperKey);
                    if (imageBytes != null) {
                      final tempDir = Directory.systemTemp;
                      final tempFile = File('${tempDir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.png');
                      await tempFile.writeAsBytes(imageBytes);


                      int retryCount = 0;
                      while ((!tempFile.existsSync() || await tempFile.length() == 0) && retryCount < 5) {
                        await Future<void>.delayed(const Duration(milliseconds: 200));
                        retryCount++;
                      }


                      resultFile = tempFile;
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text('crop the image'),
                ),
              ],
            ),
          );
        },
      );

      return resultFile;
    } catch (e) {
      debugPrint('Image cropping error: $e');
      return null;
    }
  }

}
