import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_abdullahtasdev_blog/data/repositories/admin_repositories/post_repositories.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart'; // Resim sıkıştırma paketi
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:developer' as developer;

class PostAddController extends GetxController {
  final PostRepository postRepository = PostRepository();

  var isLoading = false.obs;
  var isPublished = true.obs;

  // Resim ve ses dosyalarını geçici olarak tutma (web ve mobil için)
  var coverImage = Rx<File?>(null); // Geçici resim dosyası (mobil/masaüstü)
  var coverImageBytes = Rx<Uint8List?>(null); // Geçici resim byte'ları (web)
  var audioFile = Rx<File?>(null); // Geçici ses dosyası (mobil/masaüstü)
  var audioFileBytes =
      Rx<Uint8List?>(null); // Geçici ses dosyası byte'ları (web)

  var coverImageUrl = ''.obs; // Kapak görseli Firebase URL'i
  var audioUrl = ''.obs; // Ses dosyası Firebase URL'i

  // Kapak fotoğrafı seçme işlemi
  Future<void> pickCoverImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        // Web platformunda sıkıştırma yapmadan dosyayı kullanıyoruz
        coverImageBytes.value = await pickedFile.readAsBytes();
      } else {
        coverImage.value = File(pickedFile.path);
        // Mobil ve masaüstü platformlar için sıkıştırma işlemi
        final bytes = await coverImage.value!.readAsBytes();
        final compressedBytes = await _compressImage(bytes);
        if (compressedBytes != null) {
          coverImageBytes.value =
              compressedBytes; // Sıkıştırılmış dosya byte'ları
        }
      }
    }
  }

  // Resim sıkıştırma fonksiyonu (yalnızca mobil ve masaüstü için)
  Future<Uint8List?> _compressImage(Uint8List imageBytes) async {
    try {
      return await FlutterImageCompress.compressWithList(
        imageBytes,
        minWidth: 800, // Sıkıştırılmış genişlik
        minHeight: 600, // Sıkıştırılmış yükseklik
        quality: 70, // Kalite oranı (0-100)
      );
    } catch (e) {
      developer.log("Error during image compression: $e");
      return null;
    }
  }

  // Ses dosyası seçme işlemi (Firebase'e hemen yüklemiyoruz)
  Future<void> pickAudioFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (result != null) {
      if (kIsWeb) {
        audioFileBytes.value = result.files.single.bytes;
      } else {
        audioFile.value = File(result.files.single.path!);
      }
    }
  }

  // Post ekleme işlemi sırasında dosyalar firebase'e yükleniyor
  Future<void> submitPost(String title, String content) async {
    isLoading(true);

    try {
      String? imageUrl;
      String? audioFileUrl;

      // Kapak fotoğrafını firebase'e yükleme (sadece submit sırasında)
      if (coverImageBytes.value != null || coverImage.value != null) {
        if (kIsWeb) {
          // Web için byte verilerini yükleme
          imageUrl = await _uploadBytesToFirebase(
              coverImageBytes.value!, 'cover_images', 'cover_image.jpg');
        } else {
          // Mobil ve masaüstü için dosya yükleme
          imageUrl =
              await _uploadFileToFirebase(coverImage.value!, 'cover_images');
        }
        coverImageUrl.value = imageUrl ?? '';
      }

      // Ses dosyasını firebase'e yükleme (sadece submit sırasında)
      if (audioFileBytes.value != null || audioFile.value != null) {
        if (kIsWeb) {
          // Web için byte verilerini yükleme
          audioFileUrl = await _uploadBytesToFirebase(
              audioFileBytes.value!, 'audio_files', 'audio_file.mp3');
        } else {
          // Mobil ve masaüstü için dosya yükleme
          audioFileUrl =
              await _uploadFileToFirebase(audioFile.value!, 'audio_files');
        }
        audioUrl.value = audioFileUrl ?? '';
      }

      // Post kaydetme işlemi (Firebase Storage'da resim ve ses dosyaları yüklendikten sonra)
      await postRepository.addPost(
        title,
        content,
        coverImageUrl.value,
        isPublished.value,
        audioUrl.value == '' ? null : audioUrl.value,
      );
    } catch (e) {
      developer.log("Error adding post: $e");
    } finally {
      isLoading(false);
    }
  }

  // Firebase'e dosya yükleme (mobil ve masaüstü platformları için)
  Future<String?> _uploadFileToFirebase(File file, String folderName) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('$folderName/${file.path.split('/').last}');
      final uploadTask = storageRef.putFile(file);
      final snapshot = await uploadTask.whenComplete(() => {});
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      developer.log("Error uploading file: $e");
      return null;
    }
  }

  // Firebase'e byte verileri yükleme (web için)
  Future<String?> _uploadBytesToFirebase(
      Uint8List bytes, String folderName, String fileName) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('$folderName/$fileName');
      final uploadTask = storageRef.putData(bytes);
      final snapshot = await uploadTask.whenComplete(() => {});
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      developer.log("Error uploading bytes: $e");
      return null;
    }
  }

  // Post yayın durumunu değiştir
  void togglePublishStatus(bool isPublished) {
    this.isPublished.value = isPublished;
  }
}
