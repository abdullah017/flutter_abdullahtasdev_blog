import 'package:abdullahtasdev/data/repositories/admin_repositories/post_repositories.dart';

import 'package:abdullahtasdev/presentation/admin/controllers/post_edit_controller.dart';
import 'package:get/get.dart';

class PostEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostEditController>(() => PostEditController(
        postRepository: Get.put(PostRepository()), postId: Get.find()));
  }
}
