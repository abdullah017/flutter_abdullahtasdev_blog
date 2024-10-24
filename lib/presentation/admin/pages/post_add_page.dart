import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/admin/widgets/layout/admin_layout_widget.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_abdullahtasdev_blog/presentation/admin/controllers/post_add_controller.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart'; // Ses dosyası çalma için

class PostAddPage extends StatelessWidget {
  final PostAddController controller = Get.put(PostAddController());

  final TextEditingController titleController = TextEditingController();
  final quill.QuillController contentController = quill.QuillController.basic();
  final AudioPlayer _audioPlayer = AudioPlayer(); // Ses çalma için

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

          // Zengin metin düzenleyici (Quill)
          Expanded(
            child: quill.QuillEditor.basic(
              controller: contentController,
            ),
          ),
          quill.QuillToolbar.simple(controller: contentController),
          const SizedBox(height: 16),

          // Kapak Resmi Seçme ve Önizleme
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () => controller.pickCoverImage(),
                child: const Text('Upload Cover Image'),
              ),
              Obx(() {
                if (controller.coverImageBytes.value != null) {
                  return Image.memory(
                    controller.coverImageBytes.value!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  );
                } else if (controller.coverImage.value != null) {
                  return Image.file(
                    controller.coverImage.value!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  );
                }
                return const Text('No Image Selected');
              }),
            ],
          ),
          const SizedBox(height: 16),

          // Ses Dosyası Seçme ve Oynatma/Durdurma
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () => controller.pickAudioFile(),
                child: const Text('Upload Audio File'),
              ),
              Obx(() {
                if (controller.audioFileBytes.value != null ||
                    controller.audioFile.value != null) {
                  return ElevatedButton(
                    onPressed: () {
                      if (_audioPlayer.state == PlayerState.playing) {
                        _audioPlayer.stop();
                      } else {
                        _playAudio(controller.audioFileBytes.value,
                            controller.audioFile.value);
                      }
                    },
                    child: Text(_audioPlayer.state == PlayerState.playing
                        ? 'Durdur'
                        : 'Oynat'),
                  );
                }
                return const Text('No Audio File Selected');
              }),
            ],
          ),
          const SizedBox(height: 16),

          // Yayın Durumu
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

          // Gönderiyi kaydetme butonu
          ElevatedButton(
            onPressed: () async {
              final content = jsonEncode(contentController.document
                  .toDelta()
                  .toJson()); // Quill içeriğini JSON formatına çeviriyoruz
              await controller
                  .submitPost(
                titleController.text,
                content,
              )
                  .whenComplete(() {
                Get.snackbar('Success', 'Post added successfully');
                //Get.back();
              });
            },
            child: Obx(() => controller.isLoading.value
                ? const CircularProgressIndicator()
                : const Text('Add Post')),
          ),
        ],
      ),
    );
  }

  // Ses dosyasını oynatma/durdurma fonksiyonu
  Future<void> _playAudio(Uint8List? audioBytes, File? audioFile) async {
    if (audioBytes != null) {
      // Web için
      await _audioPlayer.play(BytesSource(audioBytes));
    } else if (audioFile != null) {
      // Mobil/Masaüstü için
      await _audioPlayer.play(DeviceFileSource(audioFile.path));
    }
  }
}
