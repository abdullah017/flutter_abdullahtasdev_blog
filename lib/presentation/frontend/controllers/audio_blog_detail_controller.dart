import 'package:flutter_abdullahtasdev_blog/data/repositories/front_repositories/blog_repositories.dart';
import 'package:get/get.dart';

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

      title.value = blog!['title'];
      content.value = blog['content'];
      imageUrl.value = blog['cover_image'] ?? '';
      date.value = blog['created_at'];
      audioUrl.value = blog['audio_url'] ?? '';
    } catch (e) {
      print("Error loading audio blog: $e");
    } finally {
      isLoading(false);
    }
  }
}
