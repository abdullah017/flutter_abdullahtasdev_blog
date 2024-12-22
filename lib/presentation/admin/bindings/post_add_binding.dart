import 'package:abdullahtasdev/core/api/firebase/storage_service.dart';
import 'package:abdullahtasdev/data/repositories/admin_repositories/post_repositories.dart';
import 'package:abdullahtasdev/presentation/admin/controllers/post_add_controller.dart';
import 'package:get/get.dart';

class PostAddBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostAddController>(() => PostAddController(
        postRepository: Get.put(PostRepository()),
        storageService: Get.put(StorageService())));
  }
}
