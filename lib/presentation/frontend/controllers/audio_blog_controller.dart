import 'dart:async';
import 'package:flutter_abdullahtasdev_blog/data/repositories/front_repositories/blog_repositories.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AudioBlogController extends GetxController {
  final BlogRepository blogRepository = BlogRepository();

  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var audioBlogs = [].obs;
  int page = 1;
  final int pageSize = 10;
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
      if (!isLastPage.value && !isLoadingMore.value) {
        if (_debounce?.isActive ?? false) _debounce!.cancel();
        _debounce = Timer(const Duration(milliseconds: 200), fetchAudioBlogs);
      }
    }
  }

  Future<void> fetchAudioBlogs() async {
    if (isLastPage.value || isLoading.value || isLoadingMore.value) return;

    try {
      isLoading.value = true;
      var result = await blogRepository.fetchAudioBlogs();
      if (result.isEmpty || result.length < pageSize) {
        isLastPage.value = true;
      }
      audioBlogs.addAll(result);
      page++;
    } catch (e) {
      print("Error fetching audio blogs: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    _debounce?.cancel();
    super.onClose();
  }
}
