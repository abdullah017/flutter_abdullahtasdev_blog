import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:abdullahtasdev/data/repositories/front_repositories/blog_repositories.dart';
import 'package:flutter/material.dart';

class AudioBlogController extends GetxController {
  final BlogRepository blogRepository = BlogRepository();

  // Reactive variables
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var audioBlogs = <Map<String, dynamic>>[].obs;
  var error = ''.obs;
  var page = 1;
  final int pageSize = 10;
  var totalCount = 0.obs;
  var isLastPage = false.obs;

  late ScrollController scrollController;
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    fetchAudioBlogs();
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      if (!isLastPage.value && !isLoading.value && !isLoadingMore.value) {
        if (_debounce?.isActive ?? false) _debounce!.cancel();
        _debounce = Timer(const Duration(milliseconds: 200), () {
          fetchAudioBlogs();
        });
      }
    }
  }

  Future<void> fetchAudioBlogs() async {
    if (isLastPage.value || isLoading.value || isLoadingMore.value) return;

    try {
      if (page == 1) {
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }
      error.value = '';

      // Use the updated repository method with pagination
      var result =
          await blogRepository.fetchAudioBlogsPaginated(page, pageSize);

      totalCount.value = result['totalCount'];
      var fetchedAudioBlogs = List<Map<String, dynamic>>.from(result['posts']);
      audioBlogs.addAll(fetchedAudioBlogs);
      page++;

      if (audioBlogs.length >= totalCount.value) {
        isLastPage.value = true;
      }
    } catch (e) {
      error.value = 'Failed to load audio blogs. Please try again.';
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> resetAudioBlogs() async {
    audioBlogs.clear();
    page = 1;
    totalCount.value = 0;
    isLastPage.value = false;
    error.value = '';
    await fetchAudioBlogs();
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    _debounce?.cancel();
    super.onClose();
  }
}
