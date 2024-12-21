import 'package:abdullahtasdev/presentation/admin/controllers/post_controllers.dart';
import 'package:get/get.dart';

class PostListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostController>(
        () => PostController(postRepository: Get.find()));
  }
}
