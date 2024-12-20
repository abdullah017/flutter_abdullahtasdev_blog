import 'package:abdullahtasdev/data/models/audio_blog_model.dart';
import 'package:abdullahtasdev/data/repositories/front_repositories/blog_repositories.dart';
import 'package:get/get.dart';

class AudioBlogDetailController extends GetxController {
  final BlogRepository blogRepository;
  final int blogId;

  var audioBlog = Rxn<AudioBlog>();
  var isLoading = false.obs;

  AudioBlogDetailController(
      {required this.blogRepository, required this.blogId});

  @override
  void onInit() {
    super.onInit();
    loadAudioBlog();
  }

  Future<void> loadAudioBlog() async {
    try {
      isLoading.value = true;
      final data = await blogRepository.fetchAudioBlogById(blogId);
      if (data != null) {
        audioBlog.value = AudioBlog.fromJson(data);
      } else {
        Get.snackbar('Error', 'Audio blog bulunamadı.',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Audio blog yüklenemedi.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
