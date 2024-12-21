import 'package:abdullahtasdev/data/repositories/admin_repositories/post_repositories.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final PostRepository postRepository;

  DashboardController({required this.postRepository});

  var totalPosts = 0.obs;
  var publishedPosts = 0.obs;
  var draftPosts = 0.obs;
  var latestPosts = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    try {
      final allPosts = await postRepository.getPosts(isPublishedFilter: true);
      final drafts = await postRepository.getPosts(isPublishedFilter: false);

      totalPosts.value = allPosts.length + drafts.length;
      publishedPosts.value = allPosts.length;
      draftPosts.value = drafts.length;
      latestPosts.value =
          (allPosts + drafts).cast<Map<String, dynamic>>().take(5).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load dashboard data.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
