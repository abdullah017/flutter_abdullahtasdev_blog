// lib/presentation/frontend/controllers/blog_detail_controller.dart

import 'package:abdullahtasdev/data/models/blog_model.dart';
import 'package:abdullahtasdev/data/repositories/front_repositories/blog_repositories.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class BlogDetailController extends GetxController {
  final BlogRepository blogRepository;
  final int blogId;

  BlogDetailController({
    required this.blogRepository,
    required this.blogId,
  });

  var blog = Rxn<Blog>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadBlogDetail();
  }

  void loadBlogDetail() async {
    try {
      isLoading.value = true;
      final result = await blogRepository.fetchBlogDetail(blogId);

      if (result != null) {
        blog.value = Blog.fromJson(result);
      } else {
        Get.snackbar('Hata', 'Blog bulunamadı.',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching blog detail: $e');
      }
      Get.snackbar('Hata', 'Blog detayları alınamadı.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
