import 'package:abdullahtasdev/presentation/frontend/controllers/audio_blog_controller.dart';
import 'package:get/get.dart';

class AudioBlogBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AudioBlogController>(
        () => AudioBlogController(blogRepository: Get.find()));
  }
}
