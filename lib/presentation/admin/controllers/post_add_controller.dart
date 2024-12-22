import 'dart:typed_data';

import 'package:abdullahtasdev/core/api/firebase/storage_service.dart';
import 'package:abdullahtasdev/data/repositories/admin_repositories/post_repositories.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class PostAddController extends GetxController {
  final PostRepository postRepository;
  final StorageService storageService;
  final uuid = const Uuid();

  PostAddController(
      {required this.postRepository, required this.storageService});

  var isLoading = false.obs;
  var isPublished = true.obs;

  var coverImageBytes = Rx<Uint8List?>(null);
  var audioFileBytes = Rx<Uint8List?>(null);
  var coverImageUrl = ''.obs;
  var audioUrl = ''.obs;

  Future<void> pickCoverImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      coverImageBytes.value = result.files.first.bytes;
    }
  }

  Future<void> pickAudioFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      audioFileBytes.value = result.files.first.bytes;
    }
  }

  Future<void> uploadCoverImage() async {
    if (coverImageBytes.value != null) {
      final fileName = 'cover_${uuid.v4()}.jpg';
      coverImageUrl.value = await storageService.uploadFile(
            coverImageBytes.value!,
            'cover_images',
            fileName,
          ) ??
          '';
    }
  }

  Future<void> uploadAudioFile() async {
    if (audioFileBytes.value != null) {
      final fileName = 'audio_${uuid.v4()}.mp3';
      audioUrl.value = await storageService.uploadFile(
            audioFileBytes.value!,
            'audio_files',
            fileName,
          ) ??
          '';
    }
  }

  Future<void> submitPost(String title, String content) async {
    isLoading.value = true;
    try {
      await uploadCoverImage();
      await uploadAudioFile();

      await postRepository.addPost(
        title,
        content,
        coverImageUrl.value,
        isPublished.value,
        audioUrl.value.isEmpty ? null : audioUrl.value,
      );

      Get.snackbar('Success', 'Post added successfully',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to add post',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
