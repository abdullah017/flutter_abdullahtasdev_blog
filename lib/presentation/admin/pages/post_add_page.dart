import 'package:flutter/material.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/admin/widgets/layout/admin_layout_widget.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_abdullahtasdev_blog/presentation/admin/controllers/post_add_controller.dart';
import 'package:get/get.dart';

class PostAddPage extends StatelessWidget {
  final PostAddController controller = Get.put(PostAddController());

  final TextEditingController titleController = TextEditingController();
  final quill.QuillController contentController = quill.QuillController.basic();

  PostAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      child: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: quill.QuillEditor.basic(
              controller: contentController,
            ),
          ),
          quill.QuillToolbar.simple(controller: contentController),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Publish'),
              Obx(() => Switch(
                    value: controller.isPublished.value,
                    onChanged: (val) {
                      controller.isPublished(val);
                    },
                  )),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final content = contentController.document.toDelta().toJson();
              await controller.submitPost(
                titleController.text,
                content.toString(),
              );
              Get.snackbar('Success', 'Post added successfully');
              Get.back();
            },
            child: Obx(() => controller.isLoading.value
                ? const CircularProgressIndicator()
                : const Text('Add Post')),
          ),
        ],
      ),
    );
  }
}
