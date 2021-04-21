// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

/// Cloud Storage Service
class CloudStorageService {
  // ignore: public_member_api_docs
  CloudStorageService() {
    _storage = FirebaseStorage.instance;
    _baseRef = _storage.ref();
  }

  /// singletion instance
  static CloudStorageService instance = CloudStorageService();

  late FirebaseStorage _storage;
  late Reference _baseRef;

  final String _profileImages = 'profile_images';
  final String _messages = 'messages';
  final String _images = 'images';

  /// Upload Profile Avatar
  Future<TaskSnapshot?> uploadUserImage(String uid, File img) async {
    try {
      return _baseRef.child(_profileImages).child(uid).putFile(img);
    } catch (e) {
      debugPrint(
        'UploadImageError: ${e.toString()}',
      );
    }
  }

  /// Upload Media Content

  Future<TaskSnapshot?> uploadMediaContent(String uid, File file) async {
    final DateTime timeStamp = DateTime.now();
    String fileName = basename(file.path);
    fileName += '${timeStamp.toString()}';
    try {
      return await _baseRef
          .child(_messages)
          .child(uid)
          .child(_images)
          .child(fileName)
          .putFile(file);
    } catch (e) {
      debugPrint(
        'UploadImageError: ${e.toString()}',
      );
    }
  }
}
