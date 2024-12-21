import 'package:abdullahtasdev/presentation/admin/controllers/post_controllers.dart';
import 'package:abdullahtasdev/presentation/admin/widgets/admin_sidebar_widget.dart';
import 'package:abdullahtasdev/presentation/admin/widgets/table/post_list_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostListsPage extends GetView<PostController> {
  const PostListsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const AdminSidebar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Post Management',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),
                  Obx(() => controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : PostListTable(posts: controller.posts)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
