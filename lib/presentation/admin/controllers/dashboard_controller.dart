import 'package:abdullahtasdev/data/repositories/admin_repositories/post_repositories.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final PostRepository postRepository = PostRepository();

  var totalPosts = 0.obs;
  var publishedPosts = 0.obs;
  var draftPosts = 0.obs;
  var latestPosts = <dynamic>[].obs; // Son eklenen postları tutmak için liste

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  void loadDashboardData() async {
    var allPosts = await postRepository.getPosts(isPublishedFilter: true);
    var drafts = await postRepository.getPosts(isPublishedFilter: false);

    totalPosts(allPosts.length + drafts.length);
    publishedPosts(allPosts.length);
    draftPosts(drafts.length);

    // Son 5 postu yükle
    latestPosts.value = (allPosts + drafts).take(5).toList();
  }
}
