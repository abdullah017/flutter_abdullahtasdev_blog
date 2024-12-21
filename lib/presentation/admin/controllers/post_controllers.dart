import 'package:abdullahtasdev/data/repositories/admin_repositories/post_repositories.dart';
import 'package:get/get.dart';


class PostController extends GetxController {
  final PostRepository postRepository;

  PostController({required this.postRepository});

  var posts = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      isLoading.value = true;
      final result = await postRepository.getPosts();
      posts.value = result.cast<Map<String, dynamic>>();
    } catch (e) {
      error.value = 'Failed to load posts.';
      Get.snackbar('Error', error.value, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> togglePostStatus(int id, bool isPublished) async {
    try {
      await postRepository.updatePost(id, '', '', null, isPublished, null);
      await fetchPosts();
      Get.snackbar('Success', 'Post status updated.',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update post status.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> deletePost(int id) async {
    try {
      bool success = await postRepository.deletePost(id);
      if (success) {
        await fetchPosts();
        Get.snackbar('Success', 'Post deleted successfully.',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        throw Exception('Delete failed');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete post.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
