import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:abdullahtasdev/presentation/admin/controllers/post_edit_controller.dart';
import 'package:abdullahtasdev/presentation/admin/widgets/layout/admin_layout_widget.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class PostEditPage extends StatelessWidget {
  final int postId;

  const PostEditPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    // Controller'ı başlat ve sayfa kapandığında otomatik olarak sil
    final PostEditController controller = Get.put(
      PostEditController(postId),
      tag: postId.toString(),
    );

    return AdminLayout(
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Başlık TextField
              TextField(
                controller: controller.titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // İçerik Quill Editor
              Container(
                height: 300, // Yüksekliği ihtiyaçlarınıza göre ayarlayın
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: quill.QuillEditor(
                  controller: controller.quillController,
                  scrollController: ScrollController(),
                  focusNode: FocusNode(),
                ),
              ),
              quill.QuillToolbar.simple(
                controller: controller.quillController,
              ),
              const SizedBox(height: 16),

              // Kapak Resmi Yükleme
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => controller.pickCoverImage(),
                    icon: const Icon(Icons.upload),
                    label: const Text('Upload Cover Image'),
                  ),
                  Obx(() {
                    if (controller.coverImageBytes.value != null) {
                      return Image.memory(
                        controller.coverImageBytes.value!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      );
                    } else if (controller.coverImageUrl.value.isNotEmpty) {
                      return Image.network(
                        '${controller.coverImageUrl.value}?t=${DateTime.now().millisecondsSinceEpoch}',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Text('Failed to load image');
                        },
                      );
                    }
                    return const Text('No Image Selected');
                  }),
                ],
              ),
              const SizedBox(height: 16),

              // Ses Dosyası Yükleme
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => controller.pickAudioFile(),
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Upload Audio File'),
                  ),
                  Obx(() {
                    if (controller.audioFileBytes.value != null ||
                        controller.audioUrl.value.isNotEmpty) {
                      return ElevatedButton.icon(
                        onPressed: () {
                          if (controller.audioPlayer.state ==
                              PlayerState.playing) {
                            controller.stopAudio();
                          } else {
                            controller.playAudio();
                          }
                        },
                        icon: Icon(
                          controller.audioPlayer.state == PlayerState.playing
                              ? Icons.stop
                              : Icons.play_arrow,
                        ),
                        label: Text(
                          controller.audioPlayer.state == PlayerState.playing
                              ? 'Stop'
                              : 'Play',
                        ),
                      );
                    }
                    return const Text('No Audio File Selected');
                  }),
                ],
              ),
              const SizedBox(height: 16),

              // Yayın Durumu
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Obx(() => Checkbox(
                        value: controller.isPublished.value,
                        onChanged: (val) {
                          if (val != null) {
                            controller.isPublished.value = val;
                          }
                        },
                      )),
                  const Text('Published'),
                ],
              ),
              const SizedBox(height: 16),

              // Gönderiyi Güncelleme Butonu
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final quillContent =
                        controller.quillController.document.toDelta().toJson();
                    bool success = await controller.updatePost(
                      postId,
                      quillContent,
                      controller.coverImageUrl.value,
                      controller.audioUrl.value == ''
                          ? null
                          : controller.audioUrl.value,
                    );
                    if (success) {
                      Get.snackbar('Success', 'Post updated successfully',
                          snackPosition: SnackPosition.BOTTOM);
                      await Future.delayed(const Duration(seconds: 1));
                      Get.toNamed('/admin');
                    } else {
                      Get.snackbar('Error', 'Failed to update post',
                          snackPosition: SnackPosition.BOTTOM);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: Obx(() => controller.isLoading.value
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.0,
                          ),
                        )
                      : const Text(
                          'Update Post',
                          style: TextStyle(fontSize: 16),
                        )),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
