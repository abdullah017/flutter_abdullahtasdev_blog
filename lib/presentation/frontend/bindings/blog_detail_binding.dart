import 'package:abdullahtasdev/presentation/frontend/controllers/blog_detail_controller.dart';
import 'package:get/get.dart';

class BlogDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BlogDetailController>(() =>
        BlogDetailController(blogRepository: Get.find(), blogId: Get.find()));
  }
}
