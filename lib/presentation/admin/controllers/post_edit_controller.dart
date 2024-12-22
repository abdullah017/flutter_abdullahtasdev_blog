import 'dart:convert';
import 'dart:typed_data';
import 'package:abdullahtasdev/data/repositories/admin_repositories/post_repositories.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_quill/flutter_quill.dart' as quill;

class PostEditController extends GetxController {
  final PostRepository postRepository;
  final int postId;

  PostEditController({required this.postRepository, required this.postId});

  var isLoading = false.obs;
  var isPublished = true.obs;

  var title = ''.obs;
  var content = ''.obs;
  var coverImageUrl = ''.obs;
  var audioUrl = ''.obs;

  var coverImageBytes = Rx<Uint8List?>(null);
  var audioFileBytes = Rx<Uint8List?>(null);

  late TextEditingController titleController;
  late quill.QuillController quillController;

  @override
  void onInit() {
    super.onInit();
    titleController = TextEditingController();
    quillController = quill.QuillController.basic();

    loadPost();
  }

  @override
  void onClose() {
    titleController.dispose();
    quillController.dispose();
    super.onClose();
  }

  Future<void> loadPost() async {
    try {
      isLoading.value = true;
      final post = await postRepository.getPostById(postId);

      title.value = post['title'];
      content.value = post['content'];
      coverImageUrl.value = post['cover_image'] ?? '';
      audioUrl.value = post['audio_url'] ?? '';
      isPublished.value = post['is_published'];

      titleController.text = title.value;
      quillController.document =
          quill.Document.fromJson(jsonDecode(content.value));
    } catch (e) {
      Get.snackbar('Error', 'Failed to load post');
    } finally {
      isLoading.value = false;
    }
  }

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

  Future<void> updatePost() async {
    try {
      isLoading.value = true;
      final updatedContent = quillController.document.toDelta().toJson();

      await postRepository.updatePost(
        postId,
        titleController.text,
        jsonEncode(updatedContent),
        coverImageUrl.value,
        isPublished.value,
        audioUrl.value.isEmpty ? null : audioUrl.value,
      );

      Get.snackbar('Success', 'Post updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update post');
    } finally {
      isLoading.value = false;
    }
  }
}
