import 'package:abdullahtasdev/data/repositories/front_repositories/blog_repositories.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostSearchController extends GetxController {
  final BlogRepository blogRepository;

  PostSearchController({required this.blogRepository});

  var searchQuery = ''.obs;
  var blogs = <Map<String, dynamic>>[].obs;
  var audioBlogs = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;

  final searchController = TextEditingController();
  final focusNode = FocusNode();

  Future<void> performSearch(String query) async {
    if (query.trim().isEmpty) {
      error.value = 'Arama terimi boş olamaz.';
      return;
    }

    searchQuery.value = query;
    isLoading.value = true;
    error.value = '';
    blogs.clear();
    audioBlogs.clear();

    try {
      final blogResults = await blogRepository.searchBlogs(query);
      final audioBlogResults = await blogRepository.searchAudioBlogs(query);

      blogs.assignAll(blogResults['posts'] ?? []);
      audioBlogs.assignAll(audioBlogResults['posts'] ?? []);
    } catch (e) {
      error.value = 'Arama sırasında bir hata oluştu.';
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    focusNode.dispose();
    super.onClose();
  }
}
