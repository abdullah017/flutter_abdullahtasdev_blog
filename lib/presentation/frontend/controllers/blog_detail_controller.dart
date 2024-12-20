import 'package:abdullahtasdev/data/models/blog_model.dart';
import 'package:abdullahtasdev/data/repositories/front_repositories/blog_repositories.dart';
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

  Future<void> loadBlogDetail() async {
    isLoading.value = true;
    try {
      final result = await blogRepository.fetchBlogDetail(blogId);
      if (result != null) {
        blog.value = Blog.fromJson(result);
      } else {
        Get.snackbar('Error', 'Blog bulunamadı.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Blog detayları alınamadı.');
    } finally {
      isLoading.value = false;
    }
  }
}
