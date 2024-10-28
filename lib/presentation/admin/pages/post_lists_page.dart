import 'package:flutter/material.dart';
import 'package:abdullahtasdev/presentation/admin/controllers/post_controllers.dart';
import 'package:abdullahtasdev/presentation/admin/controllers/post_edit_controller.dart';
import 'package:abdullahtasdev/presentation/admin/pages/post_edit_page.dart';
import 'package:abdullahtasdev/presentation/admin/widgets/layout/admin_layout_widget.dart';
import 'package:get/get.dart';

class PostListPage extends StatelessWidget {
  final PostController controller = Get.put(PostController());

  PostListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.posts.isEmpty) {
          return const Center(child: Text('No posts available.'));
        }

        return ListView.builder(
          itemCount: controller.posts.length,
          itemBuilder: (context, index) {
            final post = controller.posts[index];
            return ListTile(
              title: Text(post['title']),
              subtitle: Text(post['is_published'] ? 'Published' : 'Draft'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      controller.deletePost(post['id']);
                    },
                  ),
                  Switch(
                    value: post['is_published'],
                    onChanged: (value) {
                      controller.togglePostStatus(post['id'], value);
                    },
                  ),
                ],
              ),
              onTap: () {
                // Post düzenleme sayfasına yönlendirme
                Get.to(() => PostEditPage(postId: post['id']),
                    binding: BindingsBuilder(() {
                  Get.create(() => PostEditController(post['id']),
                      tag: post['id'].toString());
                }));
              },
            );
          },
        );
      }),
    );
  }
}
