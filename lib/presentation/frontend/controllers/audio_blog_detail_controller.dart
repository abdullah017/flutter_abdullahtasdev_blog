// lib/presentation/frontend/controllers/audio_blog_detail_controller.dart

import 'package:abdullahtasdev/data/models/audio_blog_model.dart';
import 'package:abdullahtasdev/data/repositories/front_repositories/blog_repositories.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class AudioBlogDetailController extends GetxController {
  final BlogRepository blogRepository;
  final int blogId;

  AudioBlogDetailController({
    required this.blogRepository,
    required this.blogId,
  });

  var audioBlog = Rxn<AudioBlog>();
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadAudioBlog();
  }

  Future<void> loadAudioBlog() async {
    try {
      isLoading.value = true;
      var blogData = await blogRepository.fetchAudioBlogById(blogId);
      if (blogData != null) {
        audioBlog.value = AudioBlog.fromJson(blogData);
      } else {
        Get.snackbar('Hata', 'Audio blog bulunamadı.',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error loading audio blog: $e");
      }
      Get.snackbar('Hata', 'Audio blog yüklenemedi.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
