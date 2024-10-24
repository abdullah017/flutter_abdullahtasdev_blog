import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_abdullahtasdev_blog/data/repositories/admin_repositories/post_repositories.dart';
import 'package:get/get.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:audioplayers/audioplayers.dart';
import 'dart:developer' as developer;

class PostEditController extends GetxController {
  final PostRepository postRepository = PostRepository();
  final AudioPlayer audioPlayer = AudioPlayer();
  late quill.QuillController quillController;

  var isLoading = false.obs;
  var isPublished = true.obs;

  var title = ''.obs;
  var content = ''.obs;
  var coverImageUrl = ''.obs;
  var audioUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    quillController = quill.QuillController.basic();
  }

  // Post bilgilerini getir ve ekranı güncelle
  Future<void> loadPost(int id) async {
    try {
      isLoading(true);
      var post = await postRepository.getPostById(id);

      // Verileri state'e at
      title.value = post['title'];
      content.value = post['content'];
      coverImageUrl.value = post['cover_image'] ?? '';
      audioUrl.value = post['audio_url'] ?? '';
      isPublished.value = post['is_published'];

      // İçeriği Quill editöre yükle
      quillController = quill.QuillController(
        document: getContentAsDocument(), // Quill Document'ini kullan
        selection: const TextSelection.collapsed(offset: 0),
      );
    } catch (e) {
      developer.log("Error loading post: $e");
    } finally {
      isLoading(false);
    }
  }

  // Delta formatındaki içeriği düz metine çeviren yardımcı fonksiyon
  String getPlainTextFromDelta() {
    if (content.value.isNotEmpty) {
      try {
        final decodedContent = jsonDecode(content.value);
        if (decodedContent is List &&
            decodedContent.isNotEmpty &&
            decodedContent[0] is Map &&
            decodedContent[0].containsKey('insert')) {
          final document = quill.Document.fromJson(decodedContent);
          return document.toPlainText().trim();
        } else {
          developer.log("Content is not in Delta format. Using as plain text.");
          return content.value;
        }
      } catch (e) {
        developer.log("Error decoding content JSON: $e");
        return content.value;
      }
    }
    return '';
  }

  // Post bilgilerini düzenler
  Future<bool> updatePost(int id, List<dynamic> newContent,
      String? newCoverImage, String? newAudioUrl) async {
    try {
      isLoading(true);
      final newContentJson = jsonEncode(newContent);
      return await postRepository.updatePost(
        id,
        title.value,
        newContentJson,
        newCoverImage,
        isPublished.value,
        newAudioUrl,
      );
    } catch (e) {
      developer.log(e.toString());
      return false;
    } finally {
      isLoading(false);
    }
  }

  // Yayın durumunu değiştirme
  void togglePublishStatus(bool isPublished) {
    this.isPublished.value = isPublished;
  }

  // Quill'e uygun şekilde JSON formatına çevirir (Delta formatında)
  quill.Document getContentAsDocument() {
    if (content.value.isNotEmpty) {
      try {
        final decodedContent = jsonDecode(content.value);
        if (decodedContent is List &&
            decodedContent.isNotEmpty &&
            decodedContent[0] is Map &&
            decodedContent[0].containsKey('insert')) {
          return quill.Document.fromJson(decodedContent);
        } else {
          return quill.Document()..insert(0, content.value);
        }
      } catch (e) {
        developer.log("Error decoding content JSON: $e");
        return quill.Document()..insert(0, content.value);
      }
    }
    return quill.Document();
  }

  // Ses dosyasını oynat
  Future<void> playAudio() async {
    if (audioUrl.value.isNotEmpty) {
      await audioPlayer.play(UrlSource(audioUrl.value));
    }
  }

  // Ses dosyasını durdur
  Future<void> stopAudio() async {
    await audioPlayer.stop();
  }
}
