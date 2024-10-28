// lib/presentation/frontend/controllers/blog_detail_controller.dart

import 'package:flutter/foundation.dart';
import 'package:abdullahtasdev/data/repositories/front_repositories/blog_repositories.dart';
import 'package:get/get.dart';

class BlogDetailController extends GetxController {
  final BlogRepository _blogRepository = BlogRepository();
  final int blogId; // blogId parametresi eklendi

  BlogDetailController(this.blogId); // Constructor güncellendi

  var blog = {}.obs;
  var isLoading = false.obs;
  var title = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadBlogDetail(blogId);
  }

  void loadBlogDetail(int blogId) async {
    try {
      isLoading(true);
      final result = await _blogRepository.fetchBlogDetail(blogId);

      if (result != null) {
        blog.value = result;
        title.value = blog['title'] ?? 'Başlık Yok';
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching blog detail: $e');
      }
      // Hata durumunda kullanıcıya bilgi verebilirsiniz
      Get.snackbar('Hata', 'Blog detayları alınamadı.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

}
