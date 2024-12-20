import 'package:abdullahtasdev/presentation/frontend/widgets/content/blog_content_widget.dart';
import 'package:abdullahtasdev/presentation/frontend/widgets/header/blog_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/blog_controller.dart';

class BlogPage extends GetView<BlogController> {
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: controller.resetBlogs,
        child: CustomScrollView(
          controller: controller.scrollController,
          slivers: const [
            BlogHeader(),
            BlogContent(),
          ],
        ),
      ),
    );
  }
}
