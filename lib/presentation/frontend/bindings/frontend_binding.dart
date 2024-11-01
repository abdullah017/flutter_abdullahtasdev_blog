// lib/bindings/blog_binding.dart

import 'package:abdullahtasdev/data/repositories/front_repositories/blog_repositories.dart';
import 'package:get/get.dart';

class FrontEndBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BlogRepository>(() => BlogRepository());
  }
}
