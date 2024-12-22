import 'package:abdullahtasdev/presentation/admin/controllers/post_edit_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:get/get.dart';

class PostEditForm extends StatelessWidget {
  const PostEditForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PostEditController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller.titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16),
            Container(
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: quill.QuillEditor.basic(
                controller: controller.quillController,
              ),
            ),
            quill.QuillToolbar.simple(controller: controller.quillController),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: controller.pickCoverImage,
                  child: const Text('Upload Cover Image'),
                ),
                Obx(() => controller.coverImageBytes.value != null
                    ? Image.memory(
                        controller.coverImageBytes.value!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    : const Text('No Image Selected')),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: controller.pickAudioFile,
                  child: const Text('Upload Audio File'),
                ),
                Obx(() => controller.audioFileBytes.value != null
                    ? const Icon(Icons.audiotrack, size: 32)
                    : const Text('No Audio File Selected')),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Obx(() => Checkbox(
                      value: controller.isPublished.value,
                      onChanged: (value) => controller.isPublished(value!),
                    )),
                const Text('Published'),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: controller.updatePost,
              child: const Text('Update Post'),
            ),
          ],
        ),
      );
    });
  }
}
