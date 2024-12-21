import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardPostList extends StatelessWidget {
  final List<Map<String, dynamic>> posts;

  const DashboardPostList({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return ListTile(
          title: Text(post['title'] ?? 'No Title'),
          subtitle: Text(post['created_at'] ?? 'No Date'),
          trailing: const Icon(Icons.edit),
          onTap: () {
            Get.toNamed('/admin/posts/edit', arguments: post['id']);
          },
        );
      },
    );
  }
}
