import 'dart:async';
import 'package:abdullahtasdev/data/models/blog_model.dart';
import 'package:abdullahtasdev/data/repositories/front_repositories/blog_repositories.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlogController extends GetxController {
  final BlogRepository blogRepository;
  late ScrollController scrollController;
  Timer? _debounce;

  var isLoading = false.obs;
  var blogs = <Blog>[].obs;
  var page = 1;
  final int pageSize = 10;
  var totalCount = 0.obs;
  var isLastPage = false.obs;
  var error = ''.obs;

  BlogController({required this.blogRepository});

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    fetchBlogs();
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      if (!isLastPage.value && !isLoading.value) {
        if (_debounce?.isActive ?? false) _debounce!.cancel();
        _debounce = Timer(const Duration(milliseconds: 200), () {
          fetchBlogs();
        });
      }
    }
  }

  Future<void> fetchBlogs() async {
    if (isLastPage.value || isLoading.value) return;

    try {
      isLoading.value = true;
      error.value = '';
      var result = await blogRepository.fetchBlogs(page, pageSize);

      totalCount.value = result['totalCount'];
      var fetchedBlogs = List<Map<String, dynamic>>.from(result['posts']);

      var blogList = fetchedBlogs.map((json) => Blog.fromJson(json)).toList();

      blogs.addAll(blogList);

      page++;

      if (blogs.length >= totalCount.value) {
        isLastPage.value = true;
      }
    } catch (e) {
      error.value = 'Failed to load blogs. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetBlogs() async {
    blogs.clear();
    page = 1;
    totalCount.value = 0;
    isLastPage.value = false;
    error.value = '';
    await fetchBlogs();
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    _debounce?.cancel();
    super.onClose();
  }
}
