import 'package:flutter_abdullahtasdev_blog/data/repositories/front_repositories/blog_repositories.dart';
import 'package:get/get.dart';

class BlogController extends GetxController {
  final BlogRepository blogRepository = BlogRepository();

  var isLoading = false.obs;
  var blogs = [].obs; // Blog verilerini tutacak liste

  @override
  void onInit() {
    super.onInit();
    fetchBlogs(); // Sayfa yüklendiğinde verileri çeker
  }

  void fetchBlogs() async {
    try {
      isLoading(true);
      var result = await blogRepository.fetchBlogs();
      blogs.assignAll(result);
    } catch (e) {
      print("Error fetching blogs: $e");
    } finally {
      isLoading(false);
    }
  }
}
