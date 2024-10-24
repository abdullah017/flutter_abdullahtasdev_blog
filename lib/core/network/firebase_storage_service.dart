import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:developer' as developer;


class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Dosya yükleme
  Future<String?> uploadFile(File file, String path) async {
    try {
      final ref = _storage.ref().child(path); // Firebase'deki depolama yolu
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl; // Yüklenen dosyanın URL'i
    } catch (e) {
      developer.log('Dosya yükleme hatası: $e');
      return null;
    }
  }

  // Dosya silme
  Future<void> deleteFile(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (e) {
      developer.log('Dosya silme hatası: $e');
    }
  }
}
