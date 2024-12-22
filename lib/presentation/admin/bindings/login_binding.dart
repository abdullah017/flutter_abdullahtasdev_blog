import 'package:abdullahtasdev/data/repositories/admin_repositories/auth_repository.dart';
import 'package:abdullahtasdev/presentation/admin/controllers/login_controller.dart';
import 'package:get/get.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
        () => LoginController(authRepository: Get.put(AuthRepository())));
  }
}
