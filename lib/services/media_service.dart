// Dart imports:
import 'dart:io';

// Package imports:
import 'package:image_picker/image_picker.dart';

/// Media Service
class MediaService {
  /// singleton instance
  static MediaService instance = MediaService();

  /// Get Image From Gallery
  Future<File?> getImageFromLibrary() async {
    final PickedFile? _pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );

    return File(_pickedFile!.path);
  }
}
