import 'package:abdullahtasdev/presentation/frontend/controllers/blog_controller.dart';
import 'package:get/get.dart';

class BlogBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BlogController>(
        () => BlogController(blogRepository: Get.find()));
  }
}
