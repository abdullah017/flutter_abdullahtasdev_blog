import 'package:flutter_abdullahtasdev_blog/data/repositories/post_repositories.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;

class PostController extends GetxController {
  final PostRepository postRepository = PostRepository();
  var posts = <dynamic>[].obs;
  var isLoading = false.obs;
  var isPublishedFilter = true.obs; // Yayında olanları filtreleme (default)

  // Postları yükleme
  void loadPosts() async {
    try {
      isLoading(true);
      var result = await postRepository.getPosts(
          isPublishedFilter: isPublishedFilter.value);
      posts.assignAll(result);
    } catch (e) {
      developer.log(e.toString());
    } finally {
      isLoading(false);
    }
  }

  // Post durumu değiştirme
  void togglePostStatus(int id, bool isPublished) async {
    await postRepository.updatePost(
        id, '', '', null, isPublished, null); // Sadece isPublished güncellenir
    loadPosts(); // Listeyi tekrar yükler
  }

  // Post silme işlemi
  void deletePost(int id) async {
    bool success = await postRepository.deletePost(id);
    if (success) {
      loadPosts(); // Silmeden sonra listeyi yeniden yükle
      Get.snackbar('Success', 'Post deleted successfully');
    } else {
      Get.snackbar('Error', 'Failed to delete post');
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadPosts();
  }
}
