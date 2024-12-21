import 'package:abdullahtasdev/presentation/admin/controllers/post_add_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:get/get.dart';

class PostAddForm extends StatelessWidget {
  final PostAddController controller;

  PostAddForm({super.key, required this.controller});

  final TextEditingController titleController = TextEditingController();
  final quill.QuillController contentController = quill.QuillController.basic();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Publish'),
            Obx(() => Switch(
                  value: controller.isPublished.value,
                  onChanged: (value) => controller.isPublished(value),
                )),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () async {
            final content = contentController.document.toPlainText();
            await controller.submitPost(titleController.text, content);
          },
          child: Obx(() => controller.isLoading.value
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Add Post')),
        ),
      ],
    );
  }
}
