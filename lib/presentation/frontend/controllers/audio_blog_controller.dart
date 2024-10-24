import 'package:flutter_abdullahtasdev_blog/data/repositories/front_repositories/blog_repositories.dart';
import 'package:get/get.dart';

class AudioBlogController extends GetxController {
  final BlogRepository blogRepository = BlogRepository();

  var isLoading = false.obs;
  var audioBlogs = [].obs; // Sesli blog verilerini tutacak liste

  @override
  void onInit() {
    super.onInit();
    fetchAudioBlogs(); // Sayfa yüklendiğinde verileri çeker
  }

  void fetchAudioBlogs() async {
    try {
      isLoading(true);
      var result = await blogRepository.fetchAudioBlogs();
      audioBlogs.assignAll(result);
    } catch (e) {
      print("Error fetching audio blogs: $e");
    } finally {
      isLoading(false);
    }
  }
}
