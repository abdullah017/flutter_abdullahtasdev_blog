import 'package:abdullahtasdev/data/repositories/admin_repositories/post_repositories.dart';
import 'package:abdullahtasdev/presentation/admin/controllers/dashboard_controller.dart';
import 'package:get/get.dart';

class AdminDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(
        () => DashboardController(postRepository: Get.put(PostRepository())));
  }
}
