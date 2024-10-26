import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abdullahtasdev_blog/data/repositories/admin_repositories/post_repositories.dart';
import 'package:get/get.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:developer' as developer;
import 'package:uuid/uuid.dart';

class PostEditController extends GetxController {
  final PostRepository postRepository = PostRepository();
  final AudioPlayer audioPlayer = AudioPlayer();
  late quill.QuillController quillController;

  final int postId;

  PostEditController(this.postId);

  var isLoading = false.obs;
  var isPublished = true.obs;

  var title = ''.obs;
  var content = ''.obs;
  var coverImageUrl = ''.obs;
  var audioUrl = ''.obs;

  var coverImageBytes = Rx<Uint8List?>(null);
  var audioFileBytes = Rx<Uint8List?>(null);

  // TextEditingController for the title
  late TextEditingController titleController;

  @override
  void onInit() {
    super.onInit();
    quillController = quill.QuillController.basic();
    titleController = TextEditingController();

    // Title değişikliklerini dinle ve observable'ı güncelle
    titleController.addListener(() {
      title.value = titleController.text;
    });

    // Postu yükle
    loadPost(postId);
  }

  @override
  void onClose() {
    titleController.dispose();
    audioPlayer.dispose();
    quillController.dispose();
    super.onClose();
  }

  Future<void> loadPost(int id) async {
    try {
      isLoading(true);
      var post = await postRepository.getPostById(id);

      title.value = post['title'];
      content.value = post['content'];
      coverImageUrl.value = post['cover_image'] ?? '';
      audioUrl.value = post['audio_url'] ?? '';
      isPublished.value = post['is_published'];

      titleController.text = title.value;

      quillController = quill.QuillController(
        document: getContentAsDocument(),
        selection: const TextSelection.collapsed(offset: 0),
      );
    } catch (e) {
      developer.log("Error loading post: $e");
      Get.snackbar('Error', 'Failed to load post');
    } finally {
      isLoading(false);
    }
  }

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

  Future<void> pickCoverImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      if (kIsWeb) {
        coverImageBytes.value = result.files.single.bytes;
        // Web'de byte yüklemesi yapılır
        String? newImageUrl = await _uploadBytesToFirebase(
            coverImageBytes.value!, 'cover_images', result.files.single.name);
        if (newImageUrl != null) coverImageUrl.value = newImageUrl;
      } else {
        String? newImageUrl = await _uploadFileToFirebase(
            result.files.single.path!, 'cover_images');
        if (newImageUrl != null) coverImageUrl.value = newImageUrl;
      }
    }
  }

  Future<void> pickAudioFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      if (kIsWeb) {
        audioFileBytes.value = result.files.single.bytes;
        // Web'de ek yükleme işlemleri gerekebilir
      } else {
        if (result.files.single.path == null) {
          Get.snackbar('Error', 'File path is null');
          developer.log("File path is null.");
          return;
        }
        String filePath = result.files.single.path!;
        String fileName = result.files.single.name;
        String extension = fileName.split('.').last;
        developer
            .log("Selected audio file path: $filePath, extension: $extension");
        String? newAudioUrl =
            await _uploadFileToFirebase(filePath, 'audio_files');
        if (newAudioUrl != null) {
          audioUrl.value = newAudioUrl;
          developer.log("audioUrl updated to: $newAudioUrl");
        }
      }
    } else {
      developer.log("No audio file selected.");
    }
  }

  Future<void> playAudio() async {
    if (audioUrl.value.isNotEmpty) {
      developer.log("Playing audio from URL: ${audioUrl.value}");
      await audioPlayer.play(UrlSource(audioUrl.value));
    } else if (audioFileBytes.value != null) {
      developer.log("Playing audio from bytes.");
      await audioPlayer.play(BytesSource(audioFileBytes.value!));
    }
  }

  Future<void> stopAudio() async {
    developer.log("Stopping audio playback.");
    await audioPlayer.stop();
  }

Future<bool> updatePost(int id, List<dynamic> newContent,
      String? newCoverImage, String? newAudioUrl) async {
    try {
      isLoading(true);
      final newContentJson = jsonEncode(newContent);

      final updatedCoverImageUrl = newCoverImage ?? coverImageUrl.value;
      final updatedAudioUrl = newAudioUrl ?? audioUrl.value;

      bool result = await postRepository.updatePost(
        id,
        title.value,
        newContentJson,
        updatedCoverImageUrl,
        isPublished.value,
        updatedAudioUrl == '' ? null : updatedAudioUrl,
      );

      if (result) {
        developer.log("Post updated successfully.");
      } else {
        developer.log("Post update failed.");
      }

      return result;
    } catch (e) {
      developer.log("Error updating post: $e");
      Get.snackbar('Error', 'Failed to update post');
      return false;
    } finally {
      isLoading(false);
    }
  }

  // Firebase'e dosya yükleme (benzersiz dosya adı ile)
  Future<String?> _uploadFileToFirebase(
      String filePath, String folderName) async {
    try {
      const uuid = Uuid();
      // Dosya uzantısını belirle
      String extension = filePath.split('.').last;
      // Benzersiz bir dosya adı oluştur
      final uniqueFileName = '${uuid.v4()}.$extension';

      final storageRef =
          FirebaseStorage.instance.ref().child('$folderName/$uniqueFileName');
      developer.log("Uploading file to Firebase: $uniqueFileName");

      // Dosyayı Firebase'e yükleyin
      final uploadTask = storageRef.putFile(File(filePath));
      final snapshot = await uploadTask.whenComplete(() => {});
      String downloadUrl = await snapshot.ref.getDownloadURL();

      developer.log("File uploaded. Download URL: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      developer.log("Error uploading file to Firebase: $e");
      Get.snackbar('Error', 'Failed to upload file');
      return null;
    }
  }

  // Web platformları için Firebase’e byte verilerini yükleme
  Future<String?> _uploadBytesToFirebase(
      Uint8List bytes, String folderName, String fileName) async {
    try {
      final uniqueFileName = '${const Uuid().v4()}_$fileName';
      final storageRef =
          FirebaseStorage.instance.ref().child('$folderName/$uniqueFileName');
      developer.log("Uploading file bytes to Firebase: $uniqueFileName");

      final uploadTask = storageRef.putData(bytes);
      final snapshot = await uploadTask.whenComplete(() => {});
      String downloadUrl = await snapshot.ref.getDownloadURL();

      developer.log("File bytes uploaded. Download URL: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      developer.log("Error uploading bytes to Firebase: $e");
      return null;
    }
  }
}
