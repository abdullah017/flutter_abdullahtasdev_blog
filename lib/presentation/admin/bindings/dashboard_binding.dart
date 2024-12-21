import 'package:abdullahtasdev/presentation/admin/controllers/dashboard_controller.dart';
import 'package:get/get.dart';

class AdminDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(
        () => DashboardController(postRepository: Get.find()));
  }
}
