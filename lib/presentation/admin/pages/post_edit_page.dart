import 'package:flutter/material.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/admin/controllers/post_edit_controller.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/admin/widgets/layout/admin_layout_widget.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:get/get.dart';

class PostEditPage extends StatelessWidget {
  final int postId;

  const PostEditPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final PostEditController controller = Get.put(PostEditController());

    controller.loadPost(postId);

    return AdminLayout(
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            TextField(
              controller: TextEditingController(text: controller.title.value),
              onChanged: (val) => controller.title.value = val,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: quill.QuillEditor.basic(
                controller: controller.quillController,
              ),
            ),
            quill.QuillToolbar.simple(controller: controller.quillController),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final quillContent =
                    controller.quillController.document.toDelta().toJson();
                bool success = await controller.updatePost(
                  postId,
                  quillContent,
                  controller.coverImageUrl.value,
                  controller.audioUrl.value,
                );
                if (success) {
                  Get.snackbar('Success', 'Post updated successfully');
                  await Future.delayed(
                    const Duration(seconds: 1),
                  );
                  Get.back();
                } else {
                  Get.snackbar('Error', 'Failed to update post');
                }
              },
              child: Obx(() => controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : const Text('Update Post')),
            ),
          ],
        );
      }),
    );
  }
}
