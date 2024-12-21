import 'package:abdullahtasdev/presentation/admin/controllers/post_controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostListTable extends StatelessWidget {
  final List<Map<String, dynamic>> posts;

  const PostListTable({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Title')),
        DataColumn(label: Text('Date')),
        DataColumn(label: Text('Actions')),
      ],
      rows: posts
          .map((post) => DataRow(cells: [
                DataCell(Text(post['title'] ?? 'No Title')),
                DataCell(Text(post['created_at'] ?? 'No Date')),
                DataCell(Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Get.toNamed('/admin/posts/edit', arguments: post['id']);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        Get.find<PostController>().deletePost(post['id']);
                      },
                    ),
                  ],
                )),
              ]))
          .toList(),
    );
  }
}
