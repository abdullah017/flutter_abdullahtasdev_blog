// lib/utils/navigation.dart

import 'package:abdullahtasdev/core/utils/slug_utils.dart';
import 'package:get/get.dart';

class Navigation {
  // Blog detay sayfasına yönlendirme
  static void toBlogDetail(String title, int id) {
    final slug = SlugUtils.createSlug(title, id);
    Get.toNamed('/blog-detay/$slug');
  }

  // Sesli blog detay sayfasına yönlendirme
  static void toAudioBlogDetail(String title, int id) {
    final slug = SlugUtils.createSlug(title, id);
    Get.toNamed('/sesli-blog-detay/$slug');
  }
}
