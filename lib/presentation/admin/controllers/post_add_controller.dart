import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:abdullahtasdev/data/repositories/admin_repositories/post_repositories.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:developer' as developer;
import 'package:uuid/uuid.dart';

class PostAddController extends GetxController {
  final PostRepository postRepository = PostRepository();

  var isLoading = false.obs;
  var isPublished = true.obs;

  // Temporary storage for images and audio (web and mobile)
  var coverImage = Rx<File?>(null);
  var coverImageBytes = Rx<Uint8List?>(null);
  var audioFile = Rx<File?>(null);
  var audioFileBytes = Rx<Uint8List?>(null);

  var coverImageUrl = ''.obs;
  var audioUrl = ''.obs;

  // UUID generator
  final uuid = const Uuid();

  // Pick cover image
  Future<void> pickCoverImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        coverImageBytes.value = await pickedFile.readAsBytes();
      } else {
        coverImage.value = File(pickedFile.path);
        final bytes = await coverImage.value!.readAsBytes();
        final compressedBytes = await _compressImage(bytes);
        if (compressedBytes != null) {
          coverImageBytes.value = compressedBytes;
        }
      }
    }
  }

  // Compress image (mobile and desktop only)
  Future<Uint8List?> _compressImage(Uint8List imageBytes) async {
    try {
      return await FlutterImageCompress.compressWithList(
        imageBytes,
        minWidth: 800,
        minHeight: 600,
        quality: 70,
      );
    } catch (e) {
      developer.log("Error during image compression: $e");
      return null;
    }
  }

  // Pick audio file
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

  // Submit post
  Future<void> submitPost(String title, String content) async {
    isLoading(true);

    try {
      String? imageUrl;
      String? audioFileUrl;

      // Upload cover image
      if (coverImageBytes.value != null || coverImage.value != null) {
        if (kIsWeb) {
          imageUrl = await _uploadBytesToFirebase(coverImageBytes.value!,
              'cover_images', 'cover_image_${uuid.v4()}.jpg');
        } else {
          imageUrl =
              await _uploadFileToFirebase(coverImage.value!, 'cover_images');
        }
        coverImageUrl.value = imageUrl ?? '';
      }

      // Upload audio file
      if (audioFileBytes.value != null || audioFile.value != null) {
        if (kIsWeb) {
          audioFileUrl = await _uploadBytesToFirebase(audioFileBytes.value!,
              'audio_files', 'audio_file_${uuid.v4()}.mp3');
        } else {
          audioFileUrl =
              await _uploadFileToFirebase(audioFile.value!, 'audio_files');
        }
        audioUrl.value = audioFileUrl ?? '';
      }

      // Save post
      await postRepository.addPost(
        title,
        content,
        coverImageUrl.value,
        isPublished.value,
        audioUrl.value == '' ? null : audioUrl.value,
      );

      Get.snackbar('Success', 'Post added successfully');
      // Optionally, navigate back or reset fields
    } catch (e) {
      developer.log("Error adding post: $e");
      Get.snackbar('Error', 'Failed to add post');
    } finally {
      isLoading(false);
    }
  }

  // Upload file to Firebase (mobile and desktop)
  Future<String?> _uploadFileToFirebase(File file, String folderName) async {
    try {
      String extension = file.path.split('.').last;
      String uniqueFileName = '${uuid.v4()}.$extension';

      final storageRef =
          FirebaseStorage.instance.ref().child('$folderName/$uniqueFileName');
      final uploadTask = storageRef.putFile(file);
      final snapshot = await uploadTask.whenComplete(() => {});
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      developer.log("Error uploading file: $e");
      return null;
    }
  }

  // Upload bytes to Firebase (web)
  Future<String?> _uploadBytesToFirebase(
      Uint8List bytes, String folderName, String fileName) async {
    try {
      String uniqueFileName = '${uuid.v4()}_$fileName';
      final storageRef =
          FirebaseStorage.instance.ref().child('$folderName/$uniqueFileName');
      final uploadTask = storageRef.putData(bytes);
      final snapshot = await uploadTask.whenComplete(() => {});
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      developer.log("Error uploading bytes: $e");
      return null;
    }
  }
}
