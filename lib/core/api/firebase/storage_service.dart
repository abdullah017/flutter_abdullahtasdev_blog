// File: api/firebase/storage_service.dart

import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'firebase_service.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseService.instance.storage;

  Future<String?> uploadFile(
      Uint8List fileBytes, String folderName, String fileName) async {
    try {
      final ref = _storage.ref('$folderName/$fileName');
      final uploadTask = ref.putData(fileBytes);
      final snapshot = await uploadTask.whenComplete(() => {});
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Upload Error: $e");
      return null;
    }
  }

  Future<void> deleteFile(String filePath) async {
    try {
      final ref = _storage.ref(filePath);
      await ref.delete();
    } catch (e) {
      print("Delete Error: $e");
    }
  }

  Future<String?> getFileDownloadUrl(String filePath) async {
    try {
      final ref = _storage.ref(filePath);
      return await ref.getDownloadURL();
    } catch (e) {
      print("Download URL Error: $e");
      return null;
    }
  }
}
