import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:abdullahtasdev/data/repositories/front_repositories/blog_repositories.dart';

class AudioBlogDetailController extends GetxController {
  final BlogRepository blogRepository = BlogRepository();

  var title = ''.obs;
  var content = ''.obs;
  var imageUrl = ''.obs;
  var date = ''.obs;
  var audioUrl = ''.obs;
  var isLoading = true.obs;

  Future<void> loadAudioBlog(int blogId) async {
    try {
      isLoading(true);
      var blog = await blogRepository.fetchAudioBlogById(blogId);
      if (blog != null) {
        title.value = blog['title'];
        content.value = blog['content'];
        imageUrl.value = blog['cover_image'] ?? '';
        date.value = blog['created_at'];
        audioUrl.value = blog['audio_url'] ?? '';
      } else {
        throw Exception('Audio blog not found');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error loading audio blog: $e");
      }
    } finally {
      isLoading(false);
    }
  }

  String formatDate(String date) {
    if (date.isEmpty) return 'Tarih Yok';
    try {
      final parsedDate = DateTime.parse(date);
      return '${parsedDate.day.toString().padLeft(2, '0')}.${parsedDate.month.toString().padLeft(2, '0')}.${parsedDate.year}';
    } catch (e) {
      return 'Geçersiz Tarih';
    }
  }
}
