import 'package:flutter_abdullahtasdev_blog/data/repositories/front_repositories/blog_repositories.dart';
import 'package:get/get.dart';

class BlogDetailController extends GetxController {
  final blog = {}.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final blogId = Get.parameters['id'];
    if (blogId != null) {
      loadBlogDetail(int.parse(blogId));
    }
  }

  void loadBlogDetail(int blogId) async {
    try {
      isLoading(true);
      final result = await BlogRepository().fetchBlogDetail(blogId);

      if (result != null) {
        blog.value = result;
      }
    } catch (e) {
      print('Error fetching blog detail: $e');
    } finally {
      isLoading(false);
    }
  }
}
