// lib/presentation/frontend/controllers/search_controller.dart

import 'package:flutter/material.dart';
import 'package:flutter_abdullahtasdev_blog/data/repositories/front_repositories/blog_repositories.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

class PostSearchController extends GetxController {
  final BlogRepository _blogRepository = BlogRepository();

  var searchQuery = ''.obs;
  var blogs = <Map<String, dynamic>>[].obs;
  var audioBlogs = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;

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
      final blogResults = await _blogRepository.searchBlogs(query);
      final audioBlogResults = await _blogRepository.searchAudioBlogs(query);

      // 'posts' kontrolü ekleyin
      if (blogResults['posts'] != null) {
        blogs.assignAll(List<Map<String, dynamic>>.from(blogResults['posts']));
      }

      if (audioBlogResults['posts'] != null) {
        audioBlogs.assignAll(
            List<Map<String, dynamic>>.from(audioBlogResults['posts']));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
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

  // Gerekli alanlar (searchController ve focusNode)
  final searchController = TextEditingController();
  final focusNode = FocusNode();
}
